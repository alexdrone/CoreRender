import Foundation
import CoreRender
import CoreRenderObjC

func makeDemoWidget(ctx: Context) -> ConcreteNode<UIView> {
  Node(UIView.self).withLayoutSpec { spec in
    guard let view = spec.view else { return }
    view.backgroundColor = .green
    view.yoga.minWidth = 50
    view.yoga.minHeight = 50
  }.withChildren([
    UIKit.Label(text: "Hello").build()
  ]).build()
}
