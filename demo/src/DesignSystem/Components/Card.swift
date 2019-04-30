import UIKit

open class Card: UIView {
  public struct Constants {
    /// - note: See `Theme.Geometry.defaultCornerRadius`.
    public static var defaultCornerRadius: CGFloat = Theme.Geometry.defaultCornerRadius
    /// Resting depth for the card.
    public static var defaultNormalDepth = DepthPreset.depth1
    public static var defaultSelectedDepth = DepthPreset.depth3
    /// Override this constant to provide a different placeholder.
    public static var defaultPlaceHolderImage = Theme.palette.dark.image()
  }

  // Not defined as an enum so that new styles can be introduced by subclasses.
  public struct Style {
    public static let compact: String = "compact"
    public static let mid: String = "mid"
    public static let postage: String = "postage"
    public static let postageDoubleWidth: String = "postageDoubleWidth"
    public static let headline: String = "headline"
    public static let custom: String = "custom"
  }
  /// The current style.
  /// - note: Styles can be extended and their behaviours redefined by overriding the
  /// `configureCard(for:)` method in your `Card` subclass.
  public var style: String = Style.compact
  /// The card image (if available).
  /// - note: See `Constants.defaultPlaceHolderImage`.
  public var image = Constants.defaultPlaceHolderImage
  /// The card title, will be set as `titleLabel` text.
  public var title = ""
  /// The card subtitle, will be set as `subtitleLabel` text.
  public var subtitle = ""
  /// Applies the selected state to this card.
  public var isSelected: Bool = false {
    didSet { setNeedsUpdate() }
  }

  // Subviews.
  // - note: These are public so that subclasses can define new custom layout for newly
  // defiend styles.
  public var contentView = UIView()
  public var imageView = UIImageView()
  public var titleLabel = UILabel()
  public var subtitleLabel = UILabel()
  public var backgroundProtection = UIView()
  public var selectionView = UIView()

  public required override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  private func commonInit() {
    addSubview(contentView)
    contentView.addSubview(imageView)
    contentView.addSubview(backgroundProtection)
    contentView.addSubview(titleLabel)
    contentView.addSubview(subtitleLabel)
    contentView.addSubview(selectionView)
    setNeedsUpdate()
  }

  /// Override this method to implement new styles or override the existing ones.
  /// - note: Requires super invokation.
  open func configureCard(for style: String) {
    backgroundProtection.backgroundColor = Theme.palette.text.withAlphaComponent(0.3)
    backgroundColor = Theme.palette.light
    depthPreset = !isSelected ? Constants.defaultNormalDepth : Constants.defaultSelectedDepth
    clipsToBounds = false
    layer.cornerRadius = Constants.defaultCornerRadius
    contentView.layer.cornerRadius = layer.cornerRadius
    contentView.backgroundColor = backgroundColor
    contentView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.image = image
    imageView.clipsToBounds = true
    titleLabel.backgroundColor = backgroundColor
    subtitleLabel.backgroundColor = backgroundColor
    titleLabel.isHidden = style == Style.custom
    subtitleLabel.isHidden = style == Style.custom
    imageView.isHidden = style == Style.custom
    backgroundProtection.isHidden = style == Style.custom
    selectionView.isHidden = !isSelected
    selectionView.backgroundColor = Theme.palette.dark
    selectionView.alpha = 0.5
    if style == Style.compact || style == Style.postage || style == Style.postageDoubleWidth {
      titleLabel.attributedText = Theme.typography.style(.subtitle2).asAttributedString(title)
      subtitleLabel.attributedText = Theme.typography.style(.caption).asAttributedString(subtitle)
    }
    if style == Style.mid {
      titleLabel.attributedText = Theme.typography.style(.subtitle2).asAttributedString(title)
      subtitleLabel.attributedText = Theme.typography.style(.body2).asAttributedString(subtitle)
    }
    if style == Style.headline {
      titleLabel.attributedText = Theme.typography.style(.overline).withColor(Theme.palette.light)
        .asAttributedString(title)
      subtitleLabel.attributedText = Theme.typography.style(.h6).withColor(Theme.palette.light)
        .asAttributedString(subtitle)
      titleLabel.backgroundColor = .clear
      subtitleLabel.backgroundColor = .clear
    }
  }

  /// Invoke this method when the view has to be recofigured.
  public func setNeedsUpdate() {
    configureCard(for: style)
    setNeedsLayout()
  }

  /// Lays out subviews.
  open override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = bounds
    selectionView.frame = bounds
    let geometry = Constants.geometry(for: style)
    titleLabel.numberOfLines = 1
    subtitleLabel.numberOfLines = geometry.linesNo
    titleLabel.sizeToFit()
    subtitleLabel.sizeToFit()
    let margin = geometry.margin
    let imageSize = geometry.imageSize
    let labelImageOffset = style == Style.compact || style == Style.mid ? imageSize : 0
    let labelWidth = bounds.size.width - margin * 2 - labelImageOffset
    titleLabel.frame.size.width = labelWidth
    subtitleLabel.frame.size.width = labelWidth
    if style == Style.compact {
      titleLabel.frame.origin = CGPoint(x: margin, y: margin)
      subtitleLabel.frame.origin = CGPoint(x: margin, y: titleLabel.frame.maxY + margin / 2)
      imageView.frame = CGRect(
        origin: CGPoint(x: bounds.size.width - imageSize, y: 0),
        size: CGSize(width: imageSize, height: bounds.size.height))
    }
    if style == Style.mid {
      titleLabel.frame.origin = CGPoint(x: imageSize + margin, y: margin)
      subtitleLabel.frame.origin = CGPoint(
        x: imageSize + margin,
        y: titleLabel.frame.maxY + margin / 2)
      imageView.frame = CGRect(
        origin: CGPoint.zero,
        size: CGSize(width: imageSize, height: bounds.size.height))
    }
    if style == Style.postage || style == Style.postageDoubleWidth{
      titleLabel.frame.origin = CGPoint(x: margin, y: imageSize + margin)
      subtitleLabel.frame.origin = CGPoint(x: margin, y: titleLabel.frame.maxY + margin)
      imageView.frame = CGRect(
        origin: CGPoint.zero,
        size: CGSize(width: bounds.size.width, height: imageSize))
    }
    if style == Style.headline {
      subtitleLabel.frame.origin = CGPoint(
        x: margin,
        y: bounds.size.height - margin - subtitleLabel.bounds.size.height)
      titleLabel.frame.origin = CGPoint(
        x: margin,
        y: subtitleLabel.frame.origin.y - margin - titleLabel.bounds.size.height)
      imageView.frame = CGRect(
        origin: CGPoint.zero,
        size: bounds.size)
    }
    backgroundProtection.frame = imageView.frame
  }

  /// Override this method to implement new styles or override the existing ones.
  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    var result = CGSize(
      width: style == Style.postage ? size.width / 2 : size.width,
      height: 0)
    result.height = Constants.geometry(for: style).height
    return result
  }
}

// MARK: - Constants (Geometry)

extension Card.Constants {
  // Associated intrinsic constants.
  struct Geometry {
    let height: CGFloat
    let margin: CGFloat
    let imageSize: CGFloat
    let linesNo: Int
  }
  /// Returns the layout constants for a given style.
  static func geometry(for style: String) -> Geometry {
    if style == Card.Style.compact {
      return Geometry(height: 72, margin: 16, imageSize: 98, linesNo: 2)
    }
    if style == Card.Style.mid {
      return Geometry(height: 120, margin: 16, imageSize: 120, linesNo: 3)
    }
    if style == Card.Style.postage || style == Card.Style.postageDoubleWidth {
      return Geometry(height: 240, margin: 8, imageSize: 140, linesNo: 3)
    }
    if style == Card.Style.headline {
      return Geometry(height: 344, margin: 16, imageSize: 0, linesNo: 4)
    }
    return Geometry(height: 0, margin: 0, imageSize: 0, linesNo: 0)
  }
}
