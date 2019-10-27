import UIKit
import CoreRenderObjC

// MARK: - Function builders.

/// - note: Shorthand to build a NodeBuilder using Swift function builders.
///
/// - `withReuseIdentifier`: The reuse identifier for this node is its hierarchy.
/// Identifiers help Render understand which items have changed.
/// A custom *reuseIdentifier* is mandatory if the node has a custom creation closure.
/// - `withKey`:  A unique key for the component/node (necessary if the associated
/// component is stateful).
/// - `withViewInit`: Custom view initialization closure.
/// - `withLayoutSpec`: This closure is invoked whenever the layout is performed.
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
  _ type: V.Type = V.self,
  @NodeFunctionBuilder builder: () -> FunctionBuilderChildren = FunctionBuilderChildren.default
) -> NodeBuilder<V> {
  let children = builder().children.compactMap { $0 as? ConcreteNode }
  return NodeBuilder(type: type).withChildren(children)
}

@_functionBuilder
public struct NodeFunctionBuilder {
  /// Passes a single node written as a child view through unmodified.
  public static func buildBlock(_ nodes: AnyNode...) -> FunctionBuilderChildren {
    return FunctionBuilderChildren(children: nodes)
  }
  /// Passes a many nodes written as a child view through unmodified.
  public static func buildBlock(_ node: AnyNode) -> FunctionBuilderChildren {
    return FunctionBuilderChildren(children: [node])
  }
  /// Passes an optional node.
  public static func buildIf(_ node: AnyNode?) -> FunctionBuilderChildren {
    if let node = node {
      return FunctionBuilderChildren(children: [node])
    }
    return FunctionBuilderChildren.none
  }
}

/// Intermediate structure used as a return type from @NodeFunctionBuilder.
public struct FunctionBuilderChildren {
  /// Default (no children).
  public static let none = FunctionBuilderChildren(children: [])
  /// Returns an empty builder.
  public static let `default`: () -> FunctionBuilderChildren = {
    return FunctionBuilderChildren.none
  }
  /// The wrapped childrens.
  let children: [AnyNode]
}

// MARK: - Property setters.

/// Sets the value of a desired keypath using typesafe writable reference keypaths.
/// - parameter spec: The *LayoutSpec* object that is currently handling the view configuration.
/// - parameter keyPath: The target keypath.
/// - parameter value: The new desired value.
/// - parameter animator: Optional property animator for this change.
public func withProperty<V: UIView, T>(
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

public func withProperty<V: UIView, T: WritableKeyPathBoxableEnum>(
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

// MARK: - Alias types.

// Convenience type-erased protocols.
@objc public protocol AnyNode: class {}
@objc public protocol AnyController: class {}
@objc public protocol AnyProps: class {}
@objc public protocol AnyState: class {}

public protocol WritableKeyPathBoxableEnum {
  var rawValue: Int32 { get }
}

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

// MARK: - Common Nodes.

/// A collection of function builders for the most common `UIKit` components.
public struct UIKit {
  /// Builds a simple `UIView`.
  public static func View (
    @NodeFunctionBuilder builder: () -> FunctionBuilderChildren = FunctionBuilderChildren.default
  ) -> NodeBuilder<UIView> {
    Node(UIView.self, builder: builder)
  }
  /// A `UIView`-backed horizontal stack.
  public static func HStack (
    @NodeFunctionBuilder builder: () -> FunctionBuilderChildren = FunctionBuilderChildren.default
  ) -> NodeBuilder<UIView> {
    Node(UIView.self, builder: builder).withLayoutSpec { spec in
      spec.view?.yoga.flexDirection = .row
      spec.view?.yoga.flex()
    }
  }
  /// A `UIView`-backed vertical stack.
  public static func VStack(
    @NodeFunctionBuilder builder: () -> FunctionBuilderChildren = FunctionBuilderChildren.default
  ) -> NodeBuilder<UIView> {
    Node(UIView.self, builder: builder).withLayoutSpec { spec in
      spec.view?.yoga.flexDirection = .column
      spec.view?.yoga.flex()
    }
  }
  /// Shorthand for a `UILabel node.
  public static func Label(
    text: String,
    font: UIFont = UIFont.systemFont(ofSize: 12),
    foregroundColor: UIColor = UIColor.black,
    alignment: NSTextAlignment = .left,
    lineLimit: Int = 0,
    @NodeFunctionBuilder builder: () -> FunctionBuilderChildren = FunctionBuilderChildren.default
  ) -> NodeBuilder<UILabel> {
    Node(UILabel.self, builder: builder).withLayoutSpec { spec in
      spec.view?.text = text
      spec.view?.font = font
      spec.view?.textColor = foregroundColor
      spec.view?.textAlignment = alignment
      spec.view?.numberOfLines = lineLimit
    }
  }
  /// Shorthand for `UIButton`node.
  public static func Button(
    key: String,
    title: String,
    target: Any? = nil,
    action: Selector = #selector(NSObject.doesNotRecognizeSelector(_:)),
    @NodeFunctionBuilder builder: () -> FunctionBuilderChildren = FunctionBuilderChildren.default
  ) -> NodeBuilder<UIButton> {
    Node(UIButton.self, builder: builder).withKey(key).withViewInit { _ in
      let button = UIButton()
      button.setTitle(title, for: .normal)
      button.addTarget(target, action: action, for: .touchUpInside)
      return button
    }
  }
}
