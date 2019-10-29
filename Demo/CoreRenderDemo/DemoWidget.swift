import Foundation
import CoreRender
import CoreRenderObjC

func makeDemoWidget(ctx: Context) -> ConcreteNode<UIView> {
  UIKit.HStack {
    UIKit.View()
      .width(Const.size)
      .height(Const.size)
      .cornerRadius(Const.size/2)
      .background(.systemOrange)
      .margin(Const.margin)
      .build()
    UIKit.VStack {
      UIKit.Label(text: "Hello World", font: UIFont.boldSystemFont(ofSize: 14))
        .margin(Const.margin)
        .build()
      UIKit.Label(text: "The count is: 0")
        .margin(Const.margin)
        .build()
      UIKit.View()
        .cornerRadius(Const.cornerRadius)
        .build()
    }.build()
  }
  .alignContent(.center)
  .cornerRadius(Const.cornerRadius)
  .padding(Const.margin)
  .margin(Const.margin)
  .background(UIColor.secondarySystemBackground)
  .matchParentWidth(withMargin: Const.screenMargin)
  .build()
  
}

struct Const {
  static let size: CGFloat = 48.0
  static let cornerRadius: CGFloat = 8.0
  static let screenMargin: CGFloat = 8.0
  static let margin: UIEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
}
