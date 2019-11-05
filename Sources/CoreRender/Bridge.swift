import Foundation
import UIKit
import CoreRenderObjC

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
  /// Passes a single node written as a child view through unmodified.
  public static func buildBlock(_ nodes: AnyNode...) -> _Builder {
    let children = nodes.filter { $0 !== NullNode.nullNode }
    return _Builder(children: children)
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

// MARK: - CoordinatorDescriptor

/// Creates a new CoordinatorDescriptor use to retrieve and/or pass new argument to a coordinator.
public func makeCoordinatorDescriptor<C: Coordinator<S, P>, S, P>(
  _ type: C.Type
) -> AnyCoordinatorDescriptor {
  CoordinatorDescriptor<C, S, P>()
}

public func makeCoordinatorDescriptor<C: Coordinator<S, P>, S, P>(
  _ coordinator: C
) -> AnyCoordinatorDescriptor {
  CoordinatorDescriptor<C, S, P>(
    type: C.self,
    key: coordinator.key,
    initialState: coordinator.state,
    props: coordinator.props)
}

/// Base class for any coordinator.
open class Coordinator<S: State, P: Props>: objc_Coordinator {
  /// The current coordinator state.
  public var state: S {
    get { self.anyState as! S }
    set { self.anyState = newValue }
  }
  /// The props currently assigned to this coordinator.
  public var props: P {
    get { self.anyProps as! P }
    set { self.anyProps = newValue }
  }
  
  public func descriptor() -> AnyCoordinatorDescriptor {
    return CoordinatorDescriptor(type: Self.self, key: key, initialState: state, props: props)
  }
}

public extension TypeErasedNodeBuilder {
  /// Bind the given coordinator to the node hierarchy.
  func withCoordinator(_ descriptor: AnyCoordinatorDescriptor) -> Self {
    return withCoordinatorDescriptor(descriptor.toRef())
  }
}

public protocol AnyCoordinatorDescriptor {
  /// Returns a new coordinator descriptor with a different key.
  func withKey(key newKey: String) -> Self
  /// Returns a new coordinator descriptor with new props.
  func withProps(props: Props) -> Self
  /// Build a objc ref-based object descriptor.
  func toRef() -> objc_CoordinatorDescriptor
}

/// See `makeCoordinatorDescriptor` to construct a new descriptor.
/// - note: Use the `toRef` method to pass the descriptor straight to some objc apis.
public struct CoordinatorDescriptor<C: Coordinator<S, P>, S: State, P: Props>
  : AnyCoordinatorDescriptor {
  /// The coordinator type.
  let type: C.Type
  /// The coordinator key.
  var key: String
  /// The coordinator initial state.
  let initialState: S
  /// The coordinator volatile props.
  var props: P

  /// See `makeCoordinatorDescriptor` to construct a new descriptor.
  fileprivate init(
    type: C.Type = C.self,
    key: String = String(describing: C.self),
    initialState: S = S(),
    props: P = P()
  ) {
    self.type = type
    self.key = key
    self.props = props
    self.initialState = initialState
  }
  /// Returns a new coordinator descriptor with a different key.
  public func withKey(key: String) -> Self {
    assign(self) { $0.key = key }
  }
  /// Returns a new coordinator descriptor with new props.
  public func withProps(props: Props) -> Self {
    assign(self) {
      guard let props = props as? P else { return }
      $0.props = props
    }
  }
  /// - note: Use the `toRef` method to pass the descriptor straight to some objc apis.
  public func toRef() -> objc_CoordinatorDescriptor {
    objc_CoordinatorDescriptor(type: type, key: key, initialState: initialState, props: props)
  }
  
  private func assign<T>(_ value: T, changes: (inout T) -> Void) -> T {
    var copy = value
    changes(&copy)
    return copy
  }
}


