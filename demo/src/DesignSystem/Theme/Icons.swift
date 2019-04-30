import UIKit

// See *Icons.generated.swift*.

extension UIImageView {
  /// Configure this image view to work with the icon passed as argument.
  /// - parameter icon: The icon name, see *Icons.generated.swift*.
  /// - parameter size: The optional icon size (with the assumption that the icon is squared).
  /// - parameter color: Tint the image with the desired color.
  @discardableResult
  func withIcon(_ icon: String, size: CGFloat? = nil, color: UIColor? = nil) -> UIImageView {
    guard let icon = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate) else { return self }
    image = icon
    if let size = size { frame.size = CGSize(width: size, height: size) }
    if let color = color { tintColor = color }
    return self
  }
}

public extension UIImage {
  /// Tint the image with the desired color.
  func withTintColor(_ color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
    let context: CGContext = UIGraphicsGetCurrentContext()!
    context.translateBy(x: 0, y: self.size.height)
    context.scaleBy(x: 1.0, y: -1.0)
    context.setBlendMode(CGBlendMode.normal)
    let rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
    context.clip(to: rect, mask: self.cgImage!)
    color.setFill()
    context.fill(rect)
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }

  /// Resize an image.
  func byResizingToTargetHeight(_ targetHeight: CGFloat) -> UIImage {
    let size = self.size
    let heightRatio = targetHeight / size.height
    let newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
}
