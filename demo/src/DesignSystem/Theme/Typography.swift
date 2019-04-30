import UIKit

// MARK: - Public interface

public class Typography {
  /// Scale text in your interface automatically by using Dynamic Type and `UIFontMetrics`.
  /// - note: This is supported only on iOS 11.
  public static var enableDynamicType: Bool = true
  /// - returns: The font name for the given weight.
  /// - note: A `nil` provider results in the system font.
  public typealias FontNameProvider = (FontWeight) -> String

  /// Represents the desired font weight.
  public enum FontWeight: String {
    case light
    case regular
    case medium
    /// Returns the associated *UIFontWeight* value.
    var fontWeight: UIFont.Weight {
      switch self {
      case .light:
        return UIFont.Weight.light
      case .regular:
        return UIFont.Weight.regular
      case .medium:
        return UIFont.Weight.medium
      }
    }
  }

  /// Target the desired font family.
  public enum Family: String {
    case primary
    case secondary
  }

  /// Typographic scale.
  public enum Style: String {
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
    case body1
    case body2
    case subtitle1
    case subtitle2
    case button
    case caption
    case overline
  }

  /// Short-hand font constructor.
  public static func font(family: Family, weight: FontWeight = .regular, size: CGFloat) -> UIFont {
    var provider: Typography.FontNameProvider? = nil
    switch family {
    case .primary:
      provider = Theme.typography.primaryFontFamily
    case .secondary:
      provider = Theme.typography.secondaryFontFamily
    }
    guard let fontProvider = provider else {
      return UIFont.systemFont(ofSize: size, weight: weight.fontWeight)
    }
    return UIFont(name: fontProvider(weight), size: size)!
  }

  /// Fonts and its attributes.
  public struct StyleDescriptor {
    /// The typeface.
    private let internalFont: UIFont
    /// The font letter spacing.
    private let kern: CGFloat
    /// Whether this typeface is meant to be used with uppercased text.
    private var uppercase: Bool
    /// Whether this font support dybamic font size.
    private var supportDynamicType: Bool
    /// The font color.
    public var color: UIColor
    /// Publicly exposed font (subject to font scaling if appliocable).
    public var font: UIFont {
      guard enableDynamicType, supportDynamicType else {
        return internalFont
      }
      if #available(iOS 11.0, *) {
        return UIFontMetrics.default.scaledFont(for: internalFont)
      } else {
        return internalFont
      }
    }

    public init(
      font: UIFont,
      kern: CGFloat,
      uppercase: Bool = false,
      supportDynamicType: Bool = false,
      color: UIColor = Theme.palette.text) {
      self.internalFont = font
      self.kern = kern
      self.uppercase = uppercase
      self.supportDynamicType = supportDynamicType
      self.color = color
    }

    /// Returns a dictionary of attributes for `NSAttributedString`.
    public var attributes: [NSAttributedString.Key: Any] {
      return [
        NSAttributedString.Key.font: font,
        NSAttributedString.Key.foregroundColor: color,
        NSAttributedString.Key.kern: kern
      ]
    }
    /// Override the `NSForegroundColorAttributeName` attribute.
    public func withColor(_ override: UIColor) -> StyleDescriptor {
      return StyleDescriptor(
        font: internalFont,
        kern: kern,
        uppercase: uppercase,
        supportDynamicType: supportDynamicType,
        color: override)
    }
    /// Returns an attributed string with the current font descriptor attributes.
    public func asAttributedString(_ string: String) -> NSAttributedString {
      let displayString = uppercase ? string.uppercased() : string
      return NSAttributedString(string: displayString, attributes: attributes)
    }
  }
}

public protocol TypographyProtocol {
  /// Returns the primary font provider.
  var primaryFontFamily: Typography.FontNameProvider? { get }
  /// Returns the secondary font provider.
  var secondaryFontFamily: Typography.FontNameProvider? { get }
  /// Return the font style for the given typographic scale argument.
  func style(_ scale: Typography.Style) -> Typography.StyleDescriptor
}

// MARK: - Default typography

public class BaseTypography: TypographyProtocol {
  public let primaryFontFamily: Typography.FontNameProvider? = nil
  public let secondaryFontFamily: Typography.FontNameProvider? = nil

  public func style(_ scale: Typography.Style) -> Typography.StyleDescriptor {
    switch scale {
    case .h1:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .primary, weight: .light, size: 97.54),
        kern: -1.5)
    case .h2: return
      Typography.StyleDescriptor(
        font: Typography.font(family: .primary, weight: .light, size: 60.96),
        kern: -0.5)
    case .h3:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .primary, weight: .regular, size: 48.77),
        kern: 0)
    case .h4:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .primary, weight: .regular, size: 34.54),
        kern: 0.25)
    case .h5:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .primary, weight: .medium, size: 24.38),
        kern: 0)
    case .h6:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .primary, weight: .light, size: 14.26),
        kern: 0.25)
    case .body1:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .secondary, weight: .regular, size: 14.26),
        kern: 0.5,
        supportDynamicType: true)
    case .body2:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .secondary, weight: .regular, size: 12.22),
        kern: 0.25,
        supportDynamicType: true)
    case .subtitle1:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .secondary, weight: .medium, size: 16.25),
        kern: 0.15,
        supportDynamicType: true)
    case .subtitle2:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .secondary, weight: .medium, size: 14.22),
        kern: 0.1,
        supportDynamicType: true)
    case .button:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .primary, weight: .medium, size: 12.22),
        kern: 1.25,
        uppercase: true,
        supportDynamicType: true)
    case .caption:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .secondary, weight: .regular, size: 12.19),
        kern: 0.4,
        supportDynamicType: true)
    case .overline:
      return Typography.StyleDescriptor(
        font: Typography.font(family: .primary, weight: .medium, size: 12.19),
        kern: 2,
        uppercase: true,
        supportDynamicType: true)
    }
  }
}



