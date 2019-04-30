import UIKit

public class TextField: UITextField {
  // Internal constants.
  public struct Constants {
    public static var defaultHeight: CGFloat = 48
    public static var defaultLeftPadding: CGFloat = 12
    public static var defaultCornerRadius: CGFloat = Theme.Geometry.defaultCornerRadius
    public static var defaultIconSize: CGFloat = 24
    public static var defaultNormalDepth = DepthPreset.depth1
    public static var defaultActiveDepth = DepthPreset.depth3
  }
  /// The textfield change elevation on touch.
  private var isRaised: Bool = false

  public convenience init(
    placeholder: String,
    icon: String? = nil,
    raised: Bool = true
  ) {
    self.init(frame: CGRect.zero)
    self.placeholder = placeholder
    self.isRaised = raised
    backgroundColor = Theme.palette.light
    layer.cornerRadius = Constants.defaultCornerRadius
    layer.masksToBounds = false
    if (isRaised) {
      depthPreset = Constants.defaultNormalDepth
    } else {
      layer.borderWidth = 1
      layer.borderColor = Theme.palette.hairline.cgColor
    }
    font = Theme.typography.style(.subtitle2).font
    textColor = Theme.palette.text
    if let icon = icon {
      leftImage = UIImage(named: icon)
    }
    updateView()
  }

  // Provides left padding for images
  open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    var textRect = super.leftViewRect(forBounds: bounds)
    textRect.origin.x += leftPadding
    return textRect
  }
  /// The desired left icon.
  public var leftImage: UIImage? {
    didSet { updateView() }
  }
  /// Padding for the left icon.
  public var leftPadding: CGFloat = Constants.defaultLeftPadding
  /// Transform the text into attributed text whenever is set.
  open override var text: String? {
    didSet { updateView() }
  }
  /// Override is focused to get elevation change.
  open override func becomeFirstResponder() -> Bool {
    let result = super.becomeFirstResponder()
    guard isRaised else {
      return result
    }
    depthPreset = result ? Constants.defaultActiveDepth : Constants.defaultNormalDepth
    Haptic.selection.generate()
    return result
  }

  open override func resignFirstResponder() -> Bool {
    let result = super.resignFirstResponder()
    guard isRaised else {
      return result
    }
    depthPreset = result ? Constants.defaultNormalDepth : Constants.defaultActiveDepth
    return result
  }

  private func updateView() {
    if let image = leftImage {
      leftViewMode = UITextField.ViewMode.always
      let imageView = UIImageView(frame:CGRect(
        x: 0,
        y: 0,
        width: Constants.defaultIconSize + Constants.defaultLeftPadding,
        height: Constants.defaultIconSize))
      imageView.contentMode = .scaleAspectFit
      imageView.image = image
      imageView.tintColor = Theme.palette.primary(.tint700)
      leftView = imageView
    } else {
      leftViewMode = UITextField.ViewMode.always
      leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 0))
    }
    // Placeholder text color
    let placeholder = self.placeholder ?? ""
    attributedPlaceholder =
      Theme.typography
        .style(.subtitle2)
        .withColor(Theme.palette.primary(.tint700))
        .asAttributedString(placeholder)
    if let text = text {
      attributedText =
        Theme.typography
          .style(.subtitle2)
          .withColor(Theme.palette.text)
          .asAttributedString(text)
    }
  }

  /// Asks the view to calculate and return the size that best fits the specified size.
  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: Constants.defaultHeight)
  }
}
