import XCTest
import CoreRenderObjC
import CoreRender

class FooController: Controller<FooProps, FooState>, ControllerProtocol {
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

  func testNodeWithAController() {
    let node = Node(UIView.self)
      .withControllerType(
        FooController.self,
        key: "foo",
        initialState: NullState(),
        props: FooProps())
      .withLayoutSpec { spec in
        guard let _ = spec.controller(ofType: FooController.self) else { fatalError() }
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
    let provider = ctx.controllerProvider(type: FooController.self, key: key)
    
    return UIKit.VStack {
      UIKit.Label(text: "count").build()
      UIKit.Button(title: "Increse", action: {
        guard let controller = provider?.controller else { return }
        controller.increase()
      }).build()
    }
    .withControllerType(
      FooController.self,
      key: key, initialState: FooState(),
      props: NullProps.null)
    .build()
  }
  
  func makeCounterNodeWithHelpers(ctx: Context, controller: FooController) -> ConcreteNode<UIView> {
    UIKit.VStack {
      UIKit.Label(text: "count \(controller.state.count)").build()
      UIKit.Button(title: "Increse", action: {
        controller.increase()
      }).build()
    }
    .withController(controller, initialState: FooState(), props: NullProps.null)
    .build()
  }
}

