import Foundation
import CoreRender
import CoreRenderObjC

func makeDemoWidget(ctx: Context, coordinator: CounterCoordinator) -> NodeBuilder<UIView> {
  UIKit.HStack {
    UIKit.View()
      .width(Const.size)
      .height(Const.size)
      .cornerRadius(Const.size/2)
      .background(.systemOrange)
      .margin(Const.margin)
      .alignSelf(.center)
      .build()
    UIKit.VStack {
      Node(UIButton.self)
        .font(UIFont.systemFont(ofSize: 12, weight: .bold))
        .setTarget(coordinator, action: #selector(CounterCoordinator.increase), for: .touchUpInside)
        .build()
      UIKit.Label(text: "The count is: \(coordinator.state.count)")
        .margin(Const.margin)
        .build()
    }
    .justifyContent(.flexStart)
    .build()
  }
  .cornerRadius(Const.cornerRadius)
  .padding(Const.margin)
  .margin(Const.margin)
  .background(UIColor.secondarySystemBackground)
  .matchHostingViewWidth(withMargin: Const.margin * 2)
}

// MARK: - Coordinator

class CounterState: State {
  var count: UInt = 0
}

class CounterCoordinator: Coordinator<CounterState, NullProps> {
  @objc func increase() {
    state.count += 1
    body?.setNeedsLayout()
  }
}

// MARK: - Constants

struct Const {
  static let size: CGFloat = 48.0
  static let cornerRadius: CGFloat = 8.0
  static let margin: CGFloat = 4.0
}
