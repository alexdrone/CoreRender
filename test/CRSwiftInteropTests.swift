import XCTest
import UIKit
@testable import CoreRender

class FooController: StatelessController<FooProps>, ControllerProtocol {
  typealias StateType = NullState
  typealias PropsType = FooProps
}
class FooProps: Props { }
class BarProps: Props { }

class CRSwiftInteropTests: XCTestCase {

  func buildLabelNode(ctx: Context) -> ConcreteNode<UILabel> {
    let _ = LayoutOptions.none
    return Node(type: UILabel.self, layoutSpec: { spec in
      ctx.set(spec, keyPath: \.text, value: "Hello")
      ctx.set(spec, keyPath: \.yoga.margin, value: 5)
    })
  }

  func testNodeWithAController() {
    let node = Node(
      type: UIView.self,
      controllerType: FooController.self,
      props: FooProps()
    ) { spec in
      guard let _ = spec.controller(ofType: FooController.self) else { fatalError() }
    }
    XCTAssertNotNil(node)
  }
}
