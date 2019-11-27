import Foundation
import UIKit
import CoreRenderObjC

// MARK: - Component

/// A piece of user interface.
/// This is a transient object that represent the description of a particulat subtree at a
/// given state.
///
/// You create custom views by declaring types that conform to the `Component`
/// protocol. Implement the required `body` property to provide the content
/// and behavior for your custom view.
public func Component<C: Coordinator>(
  type: C.Type,
  context: Context,
  key: String = String(describing: type(of: C.self)),
  props: (C) -> Void = { _ in },
  body: (Context, C) -> OpaqueNodeBuilder
) -> OpaqueNodeBuilder {
  let coordinator = context.coordinator(CoordinatorDescriptor(type: C.self, key: key)) as! C
  props(coordinator)
  return body(context, coordinator).withCoordinator(coordinator)
}

// MARK: - Function builders

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
/// - `withCoordinatorDescriptor:initialState.props`: Associates a coordinator to this node.
/// - `build`: Builds the concrete node.
public func Node<V: UIView>(
  _ type: V.Type = V.self,
  @_ContentBuilder builder: () -> _Builder = _Builder.default
) -> NodeBuilder<V> {
  let children = builder().children.compactMap { $0 as? ConcreteNode }
  return NodeBuilder(type: type).withChildren(children)
}

@_functionBuilder
public struct _ContentBuilder {
  public static func buildBlock(_ nodes: OpaqueNodeBuilder...) -> _Builder {
    let children = nodes.filter { $0 !== NullNode.nullNode }
    return _Builder(children: children.map { $0.build() })
  }
}

/// Intermediate structure used as a return type from @_ContentBuilder.
public struct _Builder {
  /// Default (no children).
  public static let none = _Builder(children: [])
  /// Returns an empty builder.
  public static let `default`: () -> _Builder = {
    return _Builder.none
  }
  /// The wrapped childrens.
  let children: [AnyNode]
}

// MARK: - Property setters

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

// MARK: - Alias types

// Drops the YG prefix.
public typealias FlexDirection = YGFlexDirection
public typealias Align = YGAlign
public typealias Edge = YGEdge
public typealias Wrap = YGWrap
public typealias Display = YGDisplay
public typealias Overflow = YGOverflow

public typealias LayoutOptions = CRNodeLayoutOptions

// Ensure that Yoga's C-enums are accessibly through KeyPathRefs.
public protocol WritableKeyPathBoxableEnum {
  var rawValue: Int32 { get }
}

extension YGFlexDirection: WritableKeyPathBoxableEnum { }
extension YGAlign: WritableKeyPathBoxableEnum { }
extension YGEdge: WritableKeyPathBoxableEnum { }
extension YGWrap: WritableKeyPathBoxableEnum { }
extension YGDisplay: WritableKeyPathBoxableEnum { }
extension YGOverflow: WritableKeyPathBoxableEnum { }


