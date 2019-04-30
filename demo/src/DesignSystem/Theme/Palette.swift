import UIKit

// MARK: - Public inteface

public struct Palette {
  /// Swatch styles.
  public enum Style: String {
    case tintBase
    case tint900
    case tint800
    case tint700
    case tint600
    case tint500
    case tint400
    case tint300
    case tint200
    case tint100
    case tint50
    case text
    case textHigh
    case textDisabled
    case invertedText
    case invertedTextHigh
    case invertedTextDisabled
  }
}

public protocol PaletteProtocol {
  var surface: UIColor { get }
  var light: UIColor { get }
  var dark: UIColor { get }
  var text: UIColor { get }
  var textHigh: UIColor { get }
  var textDisabled: UIColor { get }
  var hairline: UIColor { get }

  /// Returns all of the colors that belong to the primary swatch.
  func primary(_ style: Palette.Style) -> UIColor
  /// Returns all of the colors that belong to the secondary swatch.
  func secondary(_ style: Palette.Style) -> UIColor
}

// MARK: - Default palette

public class BasePalette: PaletteProtocol {
  public let surface = UIColor("#f8f9fa")
  public let light = UIColor("#ffffff")
  public let dark = UIColor("#f1f3f4")
  public let text = UIColor("#130c0c")
  public let textHigh = UIColor("#000000")
  public let textDisabled = UIColor("#000000").withAlphaComponent(0.38)
  public let hairline = UIColor("#dadce0")

  public func primary(_ style: Palette.Style) -> UIColor {
    switch style {
    case .tintBase:
      return UIColor("#5f6368")
    case .tint900:
      return UIColor("#202124")
    case .tint800:
      return UIColor("#3c4043")
    case .tint700:
      return UIColor("#5f6368")
    case .tint600:
      return UIColor("#80868b")
    case .tint500:
      return UIColor("#9aaca6")
    case .tint400:
      return UIColor("#bdc1c6")
    case .tint300:
      return UIColor("#dadce0")
    case .tint200:
      return UIColor("#e8eaed")
    case .tint100:
      return UIColor("#f1f3f4")
    case .tint50:
      return UIColor("#f8f9fa")
    case .text:
      return text
    case .textHigh:
      return textHigh
    case .textDisabled:
      return textDisabled
    case .invertedText:
      return UIColor("#ffffff").withAlphaComponent(0.60)
    case .invertedTextHigh:
      return UIColor("#ffffff")
    case .invertedTextDisabled:
      return UIColor("#ffffff").withAlphaComponent(0.38)
    }
  }

  public func secondary(_ style: Palette.Style) -> UIColor {
    return Palette.DefaultSwatches.red(style)
  }
}

// MARK: - Internals

extension UIColor {

  /// Construct a color from a hexadecimal string.
  convenience init(_ hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(
      red: CGFloat(r) / 255,
      green: CGFloat(g) / 255,
      blue: CGFloat(b) / 255,
      alpha: CGFloat(a) / 255)
  }

  /// Returns an image with solid color.
  public func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    return UIGraphicsImageRenderer(size: size).image { rendererContext in
      self.setFill()
      rendererContext.fill(CGRect(origin: .zero, size: size))
    }
  }
}

extension Palette {
  struct DefaultSwatches {
    // Default red palette.
    static func red(_ style: Palette.Style) -> UIColor {
      switch style {
      case .tintBase:
        return UIColor("#f15258")
      case .tint900:
        return UIColor("#ba1625")
      case .tint800:
        return UIColor("#c92430")
      case .tint700:
        return UIColor("#d62b38")
      case .tint600:
        return UIColor("#e8353e")
      case .tint500:
        return UIColor("#f73e3f")
      case .tint400:
        return UIColor("#f15158")
      case .tint300:
        return UIColor("#e67379")
      case .tint200:
        return UIColor("#ef9a9e")
      case .tint100:
        return UIColor("#ffcdd5")
      case .tint50:
        return UIColor("#ffebef")
      case .text:
        return UIColor("#f15258")
      case .textHigh:
        return UIColor("#f15258")
      case .textDisabled:
        return UIColor("#000000").withAlphaComponent(0.38)
      case .invertedText:
        return UIColor("#ffffff").withAlphaComponent(0.60)
      case .invertedTextHigh:
        return UIColor("#ffffff")
      case .invertedTextDisabled:
        return UIColor("#ffffff").withAlphaComponent(0.38)
      }
    }
  }
}

