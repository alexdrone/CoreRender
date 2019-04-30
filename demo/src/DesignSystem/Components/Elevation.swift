import UIKit

public typealias Offset = UIOffset

// MARK: - Depth

public enum DepthPreset: Int {
  case none
  case depth1
  case depth2
  case depth3
  case depth4
  case depth5

  /// Converts the DepthPreset enum to a Depth value.
  public var value: Depth {
    switch self {
    case .none:
      return .zero
    case .depth1:
      return Depth(offset: Offset(horizontal: 0, vertical: 0.5), opacity: 0.3, radius: 0.5)
    case .depth2:
      return Depth(offset: Offset(horizontal: 0, vertical: 1), opacity: 0.3, radius: 1)
    case .depth3:
      return Depth(offset: Offset(horizontal: 0, vertical: 2), opacity: 0.3, radius: 2)
    case .depth4:
      return Depth(offset: Offset(horizontal: 0, vertical: 4), opacity: 0.3, radius: 4)
    case .depth5:
      return Depth(offset: Offset(horizontal: 0, vertical: 8), opacity: 0.3, radius: 8)
    }
  }
}

extension UIView {
  /// A property that manages the overall shape for the object. If either the
  /// width or height property is set, the other will be automatically adjusted
  /// to maintain the shape of the object.
  public var shapePreset: ShapePreset {
    get { return layer.shapePreset }
    set(value) { layer.shapePreset = value }
  }
  /// A preset value for Depth.
  public var depthPreset: DepthPreset {
    get { return layer.depthPreset }
    set(value) { layer.depthPreset = value }
  }
  /// Depth reference.
  public var depth: Depth {
    get { return layer.depth }
    set(value) { layer.depth = value }
  }
  /// Enables automatic shadowPath sizing.
   @objc public dynamic var isShadowPathAutoSizing: Bool {
    get { return layer.isShadowPathAutoSizing }
    set(value) { layer.isShadowPathAutoSizing = value }
  }
}

// MARK: - Internals

public struct Depth {
  /// The shadow offset.
  public var offset: Offset
  /// The shadwo opacity.
  public var opacity: Float
  /// The shadow radius.
  public var radius: CGFloat

  /// A tuple of raw values.
  private var rawValue: (CGSize, Float, CGFloat) {
    return (offset.asSize, opacity, radius)
  }

  /// Set the shadow from a preset.
  public var preset = DepthPreset.none {
    didSet {
      let depth = preset.value
      offset = depth.offset
      opacity = depth.opacity
      radius = depth.radius
    }
  }

  init(offset: Offset = .zero, opacity: Float = 0, radius: CGFloat = 0) {
    self.offset = offset
    self.opacity = opacity
    self.radius = radius
  }

  /// Initializer that takes in a DepthPreset.
  /// - Parameter preset: DepthPreset.
  init(preset: DepthPreset) {
    self.init()
    self.preset = preset
  }

  /// Static constructor for Depth with values of 0.
  /// - Returns: A Depth struct with values of 0.
  public static var zero: Depth {
    return Depth()
  }
}

extension Offset {
  /// Returns a CGSize version of the Offset.
  fileprivate var asSize: CGSize {
    return CGSize(width: horizontal, height: vertical)
  }
}

public enum ShapePreset: Int {
  case none
  case square
  case circle
}

class ContainerLayer {
  /// A reference to the CALayer.
  weak var layer: CALayer?
  /// A preset property to set the shape.
  var shapePreset = ShapePreset.none {
    didSet { layer?.layoutShape() }
  }
  /// A preset value for Depth.
  var depthPreset: DepthPreset {
    get { return depth.preset }
    set(value) { depth.preset = value }
  }
  /// Grid reference.
  var depth = Depth.zero {
    didSet {
      guard let viewLayer = layer else { return }
      viewLayer.animate()
        .shadowRadius(depth.radius)
        .shadowOffset(depth.offset.asSize)
        .shadowRadius(depth.radius)
        .duration(0.166)
        .start()

      viewLayer.shadowOffset = depth.offset.asSize
      viewLayer.shadowOpacity = depth.opacity
      viewLayer.shadowRadius = depth.radius
      viewLayer.layoutShadowPath()
    }
  }
  /// Enables automatic shadowPath sizing.
  var isShadowPathAutoSizing = false

  init(layer: CALayer?) {
    self.layer = layer
  }
}

extension CALayer {
  /// ContainerLayer Reference.
  var containerLayer: ContainerLayer {
    get {
      typealias C = ContainerLayer
      let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      guard let obj = objc_getAssociatedObject(self, &_containerLayerKey) as? C else {
        let container = ContainerLayer(layer: self)
        objc_setAssociatedObject(self, &_containerLayerKey, container, nonatomic)
        return container
      }
      return obj
    }
    set(value) {
      let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      objc_setAssociatedObject(self, &_containerLayerKey, value, nonatomic)
    }
  }
  /// A property that manages the overall shape for the object. If either the
  /// width or height property is set, the other will be automatically adjusted
  /// to maintain the shape of the object.
  var shapePreset: ShapePreset {
    get { return containerLayer.shapePreset }
    set(value) {
      containerLayer.shapePreset = value
    }
  }
  /// A preset value for Depth.
  var depthPreset: DepthPreset {
    get { return depth.preset }
    set(value) { depth.preset = value }
  }
  /// Grid reference.
  var depth: Depth {
    get { return containerLayer.depth }
    set(value) { containerLayer.depth = value }
  }
  /// Enables automatic shadowPath sizing.
  var isShadowPathAutoSizing: Bool {
    get { return containerLayer.isShadowPathAutoSizing }
    set(value) { containerLayer.isShadowPathAutoSizing = value }
  }
}

extension CALayer {
  /// Manages the layout for the shape of the view instance.
  func layoutShape() {
    guard .none != shapePreset else { return }
    if bounds.width == 0 {
      bounds.size.width = bounds.height
    }
    if bounds.height == 0 {
      bounds.size.height = bounds.width
    }
    guard .circle == shapePreset else {
      cornerRadius = 0
      return
    }
    cornerRadius = bounds.size.width / 2
  }
  /// Sets the shadow path.
  func layoutShadowPath() {
    guard isShadowPathAutoSizing else { return }
    if .none == depthPreset {
      shadowPath = nil
    } else {
      shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
  }
}

extension UIView {
  /// Manages the layout for the shape of the view instance.
  func layoutShape() {
    layer.layoutShape()
  }
  /// Sets the shadow path.
  func layoutShadowPath() {
    layer.layoutShadowPath()
  }
}

private var _containerLayerKey: UInt8 = 0

extension CALayer {
  /// Animation wrapper on CALayer.
  public func animate() -> CALayerAnimate {
    return CALayerAnimate(layer: self)
  }
}

public class CALayerAnimate {
  private var animations: [String: CAAnimation]
  private var duration: CFTimeInterval
  private let layer: CALayer

  init(layer: CALayer) {
    self.animations = [String: CAAnimation]()
    self.duration = 0.25 // second
    self.layer = layer
  }

  public func shadowOpacity(_ shadowOpacity: Float) -> CALayerAnimate {
    let key = "shadowOpacity"
    let animation = CABasicAnimation(keyPath: key)
    animation.fromValue = layer.shadowOpacity
    animation.toValue = shadowOpacity
    animation.isRemovedOnCompletion = false
    animation.fillMode = CAMediaTimingFillMode.forwards
    animations[key] = animation
    return self
  }

  public func shadowRadius(_ shadowRadius: CGFloat) -> CALayerAnimate {
    let key = "shadowRadius"
    let animation = CABasicAnimation(keyPath: key)
    animation.fromValue = layer.shadowRadius
    animation.toValue = shadowRadius
    animation.isRemovedOnCompletion = false
    animation.fillMode = CAMediaTimingFillMode.forwards
    animations[key] = animation
    return self
  }

  public func shadowOffset(_ size: CGSize) -> CALayerAnimate {
    let key = "shadowOffset"
    let animation = CABasicAnimation(keyPath: key)
    animation.fromValue = NSValue(cgSize: layer.shadowOffset)
    animation.toValue = NSValue(cgSize: size)
    animation.isRemovedOnCompletion = false
    animation.fillMode = CAMediaTimingFillMode.forwards
    animations[key] = animation
    return self
  }

  public func duration(_ duration: CFTimeInterval) -> CALayerAnimate {
    self.duration = duration
    return self
  }

  public func start() {
    for (key, animation) in animations {
      animation.duration = duration
      layer.removeAnimation(forKey: key)
      layer.add(animation, forKey: key)
    }
  }
}
