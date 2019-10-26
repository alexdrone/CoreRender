import UIKit

// MARK: - Function builders.

/// - note: Shorthand to build a NodeBuilder using Swift function builders.
///
/// - `withReuseIdentifier`: The reuse identifier for this node is its hierarchy.
/// Identifiers help Render understand which items have changed.
/// A custom *reuseIdentifier* is mandatory if the node has a custom creation closure.
/// - `withKey`:  A unique key for the component/node (necessary if the associated
/// component is stateful).
/// - `withViewInit`: Custom view initialization closure.
/// - `withLayoutSpec`: This closure is invoked whenever the 'layout' method is invoked.
/// Configure your backing view by using the *UILayout* object (e.g.):
/// ```
/// ... { spec in
///   spec.set(\UIView.backgroundColor, value: .green)
///   spec.set(\UIView.layer.borderWidth, value: 1)
/// ```
/// You can also access to the view directly (this is less performant because the infrastructure
/// can't keep tracks of these view changes, but necessary when coping with more complex view
/// configuration methods).
/// ```
/// ... { spec in
///   spec.view.backgroundColor = .green
///   spec.view.setTitle("FOO", for: .normal)
/// ```
/// - `withController:initialState.props`: Associates a controller to this node.
/// - `build`: Builds the concrete node.
public func Node<V: UIView>(
  _ type: V.Type,
  @NodeFunctionBuilder builder: () -> _NodeChildren = _NodeChildren.noneBuilder
) -> NodeBuilder<V> {
  let children = builder().children.compactMap { $0 as? ConcreteNode }
  return NodeBuilder(type: type).withChildren(children)
}

@_functionBuilder
public struct NodeFunctionBuilder {
  /// Passes a single node written as a child view through unmodified.
  public static func buildBlock(_ nodes: AnyNode...) -> _NodeChildren {
    return _NodeChildren(children: nodes)
  }
  /// Passes a many nodes written as a child view through unmodified.
  public static func buildBlock(_ node: AnyNode) -> _NodeChildren {
    return _NodeChildren(children: [node])
  }
  /// Passes an optional node.
  public static func buildIf(_ node: AnyNode?) -> _NodeChildren {
    if let node = node {
      return _NodeChildren(children: [node])
    }
    return _NodeChildren.none
  }
}

/// Intermediate structure used as a return type from @NodeFunctionBuilder.
public struct _NodeChildren {
  /// Default (no children).
  public static let none = _NodeChildren(children: [])
  /// Empty function builder.
  public static let noneBuilder: () -> _NodeChildren = {
    return _NodeChildren(children: [])
  }
  /// The wrapped childrens.
  let children: [AnyNode]
}

// MARK: - Alias types.

// Convenience type-erased protocols.
@objc public protocol AnyNode: class {}
@objc public protocol AnyController: class {}
@objc public protocol AnyProps: class {}
@objc public protocol AnyState: class {}

public protocol WritableKeyPathBoxableEnum {
  var rawValue: Int32 { get }
}
extension YGJustify: WritableKeyPathBoxableEnum {}
extension YGAlign: WritableKeyPathBoxableEnum {}
extension YGEdge: WritableKeyPathBoxableEnum {}
extension YGWrap: WritableKeyPathBoxableEnum {}
extension YGDisplay: WritableKeyPathBoxableEnum {}
extension YGOverflow: WritableKeyPathBoxableEnum {}

/// Swift-only compliance protocol.
public protocol ControllerProtocol: AnyController {
  /// The type of the props that will be passed down to this controller.
  associatedtype PropsType: AnyProps
  /// The type of its internal state
  associatedtype StateType: AnyState
}

extension ConcreteNode: AnyNode { }
extension Controller: AnyController {}
extension Props: AnyProps { }
extension State: AnyState { }

/// Retrieves a controller from the context.
public func ControllerProvider<C: AnyController> (
  _ ctx: Context,
  type: C.Type,
  key: String? = nil
) -> ControllerProvider<C> {
  if let key = key {
    return ctx.controllerProvider(ofType: type, withKey: key) as! ControllerProvider<C>
  } else {
    return ctx.controllerProvider(ofType: type) as! ControllerProvider<C>
  }
}

/// Sets the value of a desired keypath using typesafe writable reference keypaths.
/// - parameter spec: The *LayoutSpec* object that is currently handling the view configuration.
/// - parameter keyPath: The target keypath.
/// - parameter value: The new desired value.
/// - parameter animator: Optional property animator for this change.
public func Property<V: UIView, T>(
  in spec: LayoutSpec<V>,
  keyPath: ReferenceWritableKeyPath<V, T>,
  value: T,
  animator: UIViewPropertyAnimator? = nil
) -> Void {
  guard let kvc = keyPath._kvcKeyPathString else {
    print("\(keyPath) is not a KVC property.")
    return
  }
  spec.set(kvc, value: value, animator: animator);
}

public func Property<V: UIView, T: WritableKeyPathBoxableEnum>(
  in spec: LayoutSpec<V>,
  keyPath: ReferenceWritableKeyPath<V, T>,
  value: T,
  animator: UIViewPropertyAnimator? = nil
) -> Void {
  guard let kvc = keyPath._kvcKeyPathString else {
    print("\(keyPath) is not a KVC property.")
    return
  }
  let nsValue = NSNumber(value: value.rawValue)
  spec.set(kvc, value: nsValue, animator: animator)
}

public extension Context {
  /// Returns the subtree controller of the given type.
  func controller<C: AnyController, V: UIView>(
    _ spec: LayoutSpec<V>,
    type: C.Type
  ) -> C? {
    return spec.controller(ofType: C.self) as? C
  }

  /// Returns the controller provider for the given key.
  func controllerProvider<C: AnyController & NSObject> (
    type: C.Type,
    key: String? = nil
  ) -> ControllerProvider<C>? {
    return ControllerProvider(self, type: type, key: key)
  }
}

public typealias LayoutOptions = CRNodeLayoutOptions

