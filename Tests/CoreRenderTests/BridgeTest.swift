import XCTest
import CoreRenderObjC
import CoreRender

class FooCoordinator: Coordinator<FooState, FooProps> {

  func increase() { state.count += 1 }
}

class FooState: State {
  var count = 0
}

class FooProps: Props { }
class BarProps: Props { }

class CRSwiftInteropTests: XCTestCase {

  func testGetCoordinator() {
    let context = Context()
    let desc = makeCoordinatorDescriptor(FooCoordinator.self)
    let coordinator = context.coordinator(desc.toRef())
    XCTAssert(coordinator is FooCoordinator)
    let cast = coordinator as? FooCoordinator
    XCTAssert(cast != nil)
  }

}

