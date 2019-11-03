import XCTest
import CoreRenderObjC
import CoreRender

class FooCoordinator: Coordinator<FooProps, FooState>, CoordinatorProtocol {
  static let descriptor: AnyCoordinatorDescriptor =
    CoordinatorDescriptor<FooCoordinator, FooProps, FooState>()

  func increase() { state.count += 1 }
}

class FooState: State {
  var count = 0
}

class FooProps: Props { }
class BarProps: Props { }

class CRSwiftInteropTests: XCTestCase {
  let desc = FooCoordinator.descriptor

  func testNodeWithACoordinator() {
    let node = Node(UIView.self)
      .withCoordinator(desc)
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
    return UIKit.VStack {
      UIKit.Label(text: "count").build()
      UIKit.Button(title: "Increse", action: {
        guard let coordinator = ctx.coordinator(self.desc.toRef()) as? FooCoordinator else {
          return
        }
        coordinator.increase()
      }).build()
    }
    .withCoordinator(desc)
    .build()
  }

  func makeCounterNodeWithHelpers(
    ctx: Context,
    coordinator: FooCoordinator
  ) -> ConcreteNode<UIView> {
    UIKit.VStack {
      UIKit.Label(text: "count \(coordinator.state.count)").build()
      UIKit.Button(title: "Increse", action: {
        coordinator.increase()
      }).build()
    }
    .withCoordinator(desc)
    .build()
  }

  func makeCounterNodeWithHelpers2(
    ctx: Context,
    coordinator: FooCoordinator
  ) -> ConcreteNode<UIView> {
    UIKit.VStack {
      UIKit.Label(text: "count \(coordinator.state.count)").build()
      UIKit.None()
    }.build()
  }
}

