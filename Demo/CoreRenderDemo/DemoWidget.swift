import Foundation
import CoreRender
import CoreRenderObjC

func makeDemoWidget(ctx: Context, coordinator: CounterCoordinator) -> NodeBuilder<UIView> {
  UIKit.VStack {
    UIKit.View {
      UIKit.Label(
        text: "\(coordinator.state.count)",
        font: UIFont.systemFont(ofSize: 24, weight: .bold))
        .width(Const.size)
        .height(Const.size)
        .textAlignment(.center)
        .build()
      UIKit.None()
    }
      .width(Const.size)
      .height(Const.size)
      .cornerRadius(Const.size/2)
      .background(.systemOrange)
      .margin(Const.margin)
      .alignSelf(.center)
      .build()
    UIKit.HStack {
      UIKit.Button(key: "increase")
        .text("TAP HERE TO INCREASE COUNT")
        .textColor(UIColor.black)
        .font(UIFont.systemFont(ofSize: 12, weight: .bold))
        .setTarget(coordinator, action: #selector(CounterCoordinator.increase), for: .touchUpInside)
        .build()
      UIKit.Label(text: " >> \(coordinator.state.count)")
        .margin(Const.margin)
        .build()
    }
    .alignItems(.center)
    .justifyContent(.center)
    .build()
  }
  .alignItems(.center)
  .cornerRadius(Const.cornerRadius)
  .padding(Const.margin)
  .margin(Const.margin)
  .background(UIColor.secondarySystemBackground)
  .matchHostingViewWidth(withMargin: Const.margin * 2)
  .withCoordinator(coordinator.descriptor())
}

// MARK: - Coordinator

class CounterState: State {
  var count: UInt = 0
}

class CounterCoordinator: Coordinator<CounterState, NullProps> {
  @objc func increase() {
    state.count += 1
    body?.setNeedsReconcile()
  }
}

// MARK: - Constants

struct Const {
  static let size: CGFloat = 48.0
  static let cornerRadius: CGFloat = 8.0
  static let margin: CGFloat = 4.0
}
