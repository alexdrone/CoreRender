import UIKit

public class Button: UIButton {
  // Internal constants.
  public struct Constants {
    public static var defaultIconSize: CGFloat = 20
    public static var defaultCornerRadius: CGFloat = Theme.Geometry.defaultCornerRadius
    public static var defaultBorderWidth: CGFloat = 1
    public static var defaultVerticalPadding: CGFloat = 12
    public static var defaultHorizontalPadding: CGFloat = 24
  }

  public enum Style: Int {
    /// Used for primary action buttons.
    case primary
    /// Used for secondary action buttons.
    case secondary
  }
  /// Whether this button has a title laberl or not.
  private var hasTitle: Bool = false
  /// The style assigned at construction time for this button.
  private var buttonStyle: Style = .primary
  /// The button change elevation on touch.
  private var isRaised: Bool = false

  public convenience init(
    style: Button.Style,
    title: String = "",
    icon: String? = nil,
    raised: Bool = false
  ) {
    self.init()
    hasTitle = !title.isEmpty
    buttonStyle = style
    isRaised = raised
    let displayTitle = title.isEmpty ? title : "  \(title)"
    let titleFont = Theme.typography.style(.overline)
    let primaryTextColor = Theme.palette.secondary(.invertedTextHigh)
    let secondaryTextColor = Theme.palette.secondary(.textHigh)
    let textColor = buttonStyle == .primary ? primaryTextColor : secondaryTextColor
    let selectedTextColor = buttonStyle == .primary ? primaryTextColor : primaryTextColor
    let disabledTextColor = Theme.palette.textDisabled
    setAttributedTitle(
      titleFont.withColor(textColor).asAttributedString(displayTitle),
      for: .normal)
    setAttributedTitle(
      titleFont.withColor(selectedTextColor).asAttributedString(displayTitle),
      for: .selected)
    setAttributedTitle(
      titleFont.withColor(disabledTextColor).asAttributedString(displayTitle),
      for: .disabled)
    let commonControlStates = [
      UIControl.State.normal,
      UIControl.State.highlighted,
      UIControl.State.focused,
      UIControl.State.selected
    ]
    if let icon = icon, var image = UIImage(named: icon) {
      image = image.byResizingToTargetHeight(Constants.defaultIconSize)
      for state in commonControlStates {
        setImage(image.withTintColor(textColor), for: state)
      }
      setImage(image.withTintColor(selectedTextColor), for: .selected)
      setImage(image.withTintColor(disabledTextColor), for: .disabled)
    }
    layer.cornerRadius = Constants.defaultCornerRadius
    layer.borderWidth = Constants.defaultBorderWidth
    layer.borderColor = Theme.palette.hairline.cgColor
    if (!hasTitle) {
      let width = Constants.defaultIconSize + Constants.defaultHorizontalPadding
      layer.cornerRadius = width / 2
    }
    updateBackground()
    sizeToFit()
  }

  private func updateBackground() {
    let backgroundColor = buttonStyle == .primary
      ? Theme.palette.secondary(.tint600)
      : Theme.palette.light
    let backgroundColorFocused = buttonStyle == .primary
      ? backgroundColor.withAlphaComponent(0.7)
      : Theme.palette.secondary(.tint100)
    let backgroundColorSelected = buttonStyle == .primary
      ? Theme.palette.secondary(.tint900)
      : Theme.palette.secondary(.tint600)
    let backgroundDisabled = Theme.palette.primary(.tint50)

    if isHighlighted || isFocused {
      self.backgroundColor = backgroundColorFocused
    } else if isSelected {
      self.backgroundColor = backgroundColorSelected
    } else if !isEnabled {
      self.backgroundColor = backgroundDisabled
    } else {
      self.backgroundColor = backgroundColor
    }
    updateElevation()
  }

  private func updateElevation() {
    guard isRaised else {
      return
    }
    if isHighlighted || isFocused || isSelected {
      depthPreset = .depth3
    } else {
      depthPreset = .depth1
    }
  }

  // MARK: Overrides

  open override var isHighlighted: Bool {
    didSet { updateBackground() }
  }

  open override var isSelected: Bool {
    didSet { updateBackground() }
  }

  open override var isEnabled: Bool {
    didSet { updateBackground() }
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    var result = super.sizeThatFits(size)
    result.width += Constants.defaultHorizontalPadding
    result.height += hasTitle
      ? Constants.defaultVerticalPadding
      : Constants.defaultHorizontalPadding
    return result
  }
}
