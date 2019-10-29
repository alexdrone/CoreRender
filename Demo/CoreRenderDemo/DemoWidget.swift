import Foundation
import CoreRender
import CoreRenderObjC

func makeDemoWidget(ctx: Context) -> ConcreteNode<UIView> {
  UIKit.VStack {
    UIKit.Label(text: "Hello World", font: UIFont.boldSystemFont(ofSize: 14))
      .margin(Const.margin)
      .padding(Const.margin)
      .background(UIColor.secondarySystemBackground)
      .cornerRadius(8)
      .build()
    UIKit.Label(text: "The count is: 0")
      .margin(Const.margin)
      .build()
  }
    .margin(Const.margin)
    .build()
  
}

struct Const {
  static let margin: UIEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
}
