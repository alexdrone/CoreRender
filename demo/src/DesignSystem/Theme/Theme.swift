import UIKit

public struct Theme {
  public struct Geometry {
    public static var defaultCornerRadius: CGFloat = 8
  }
  /// The theme palette.
  public static var palette: PaletteProtocol = BasePalette()
  /// The theme typography.
  public static var typography: TypographyProtocol = BaseTypography()
}
