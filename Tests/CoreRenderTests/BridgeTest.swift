import XCTest
import CoreRenderObjC
import CoreRender

class FooCoordinator: Coordinator<FooProps, FooState>, CoordinatorProtocol {
  typealias StateType = FooState
  typealias PropsType = FooProps
  func increase() { state.count += 1 }
}

class FooState: State {
  var count = 0
}

class FooProps: Props { }
class BarProps: Props { }

class CRSwiftInteropTests: XCTestCase {

  func testNodeWithACoordinator() {
    let node = Node(UIView.self)
      .withCoordinatorType(
        FooCoordinator.self,
        key: "foo",
        initialState: NullState(),
        props: FooProps())
      .withLayoutSpec { spec in
        guard let _ = spec.coordinator(ofType: FooCoordinator.self) else { fatalError() }
    }
    XCTAssertNotNil(node)
  }

  func makeCounterNode(ctx: Context) -> ConcreteNode<UIView> {
    Node(UIView.self) {
      Node(UILabel.self).withLayoutSpec { spec in
        withProperty(in: spec, keyPath: \.text, value: "Test")
      }.build()
      Node(UIButton.self).build()
    }.build()
  }

  func makeCounterNodeWithHelpers(ctx: Context) -> ConcreteNode<UIView> {
    let key = "counter"
    let provider = ctx.coordinatorProvider(type: FooCoordinator.self, key: key)
    
    return UIKit.VStack {
      UIKit.Label(text: "count").build()
      UIKit.Button(title: "Increse", action: {
        guard let coordinator = provider?.coordinator else { return }
        coordinator.increase()
      }).build()
    }
    .withCoordinatorType(
      FooCoordinator.self,
      key: key, initialState: FooState(),
      props: NullProps.null)
    .build()
  }
  
  func makeCounterNodeWithHelpers(ctx: Context, coordinator: FooCoordinator) -> ConcreteNode<UIView> {
    UIKit.VStack {
      UIKit.Label(text: "count \(coordinator.state.count)").build()
      UIKit.Button(title: "Increse", action: {
        coordinator.increase()
      }).build()
    }
    .withCoordinator(coordinator, initialState: FooState(), props: NullProps.null)
    .build()
  }
  
  func makeCounterNodeWithHelpers2(ctx: Context, coordinator: FooCoordinator) -> ConcreteNode<UIView> {
    UIKit.VStack {
      UIKit.Label(text: "count \(coordinator.state.count)").build()
      UIKit.None()
    }.build()
  }
}

