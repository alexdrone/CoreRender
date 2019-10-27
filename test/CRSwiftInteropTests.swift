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

  func makeCounterNode2(ctx: Context) -> ConcreteNode<UIView> {
    UIKit.VStack {
      UIKit.Label(text: "Hello").build()
      UIKit.Button(key: "counter", title: "Increment").build()
    }.build()
  }
}
