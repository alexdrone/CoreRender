import Foundation
import CoreRender
import CoreRenderObjC

func makeDemoWidget(ctx: Context, coordinator: CounterCoordinator) -> NodeBuilder<UIView> {
  VStack {
    Label(text: "\(coordinator.state.count)")
      .font(UIFont.systemFont(ofSize: 24, weight: .black))
      .textAlignment(.center)
      .background(.systemOrange)
      .alignSelf(.center)
      .width(coordinator.state.expanded ? Const.size * 2 : Const.size)
      .height(coordinator.state.expanded ? Const.size * 2 : Const.size)
      .margin(Const.margin)
      .cornerRadius(Const.size/2)
      .userInteractionEnabled(true)
      .onTouchDown{ _ in
        coordinator.animateBadge()
      }
    HStack {
      Button(key: Const.increaseButtonKey)
        .text("TAP HERE TO INCREASE COUNT")
        .font(UIFont.systemFont(ofSize: 12, weight: .bold))
        .setTarget(coordinator, action: #selector(CounterCoordinator.increase), for: .touchUpInside)
        .textColor(UIColor.black)
        .background(UIColor.secondarySystemBackground)
        .padding(Const.margin * 2)
        .cornerRadius(Const.cornerRadius)
      None()
    }
    .alignSelf(.center)
  }
  .matchHostingViewWidth(withMargin: 0)
  .withCoordinator(coordinator.descriptor())
}

// MARK: - Coordinator

class CounterState: State {
  var expanded = false
  var count: UInt = 0
}

class CounterCoordinator: Coordinator<CounterState, NullProps> {
  @objc func increase() {
    state.count += 1
    body?.setNeedsReconcile()
  }
  
  func animateBadge() {
    state.expanded.toggle();
    self.body?.setNeedsReconcile()
  }
}

// MARK: - Constants

struct Const {
  static let increaseButtonKey = "button_increase"
  static let size: CGFloat = 48.0
  static let cornerRadius: CGFloat = 8.0
  static let margin: CGFloat = 4.0
}
