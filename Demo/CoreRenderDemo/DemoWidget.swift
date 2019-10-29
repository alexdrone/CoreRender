import Foundation
import CoreRender
import CoreRenderObjC

func makeDemoWidget(ctx: Context) -> ConcreteNode<UIView> {
  UIKit.VStack {
    UIKit.Label(text: "Hello World").build()
    UIKit.Label(text: "From CoreRender").build()
  }.build()
  
}
