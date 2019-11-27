import Foundation
import CoreRender
import CoreRenderObjC

func makeDemoWidget(ctx: Context, coordinator: CounterCoordinator) -> NodeBuilder<UIView> {
  VStackNode {
    LabelNode(text: "\(coordinator.state.count)")
      //.font(UIFont.systemFont(ofSize: 24, weight: .black))
      .textAlignment(.center)
      .textColor(.darkText)
      .background(.secondarySystemBackground)
      .width(Const.size + 8 * CGFloat(coordinator.state.count))
      .height(Const.size)
      .margin(Const.margin)
      .cornerRadius(Const.cornerRadius)
    LabelNode(text: ">> TAP HERE TO SPIN THE BUTTON >>")
      .font(UIFont.systemFont(ofSize: 12, weight: .bold))
      .textAlignment(.center)
      .textColor(.systemOrange)
      .height(Const.size)
      .margin(Const.margin)
      .userInteractionEnabled(true)
      .onTouchUpInside { _ in
        coordinator.doSomeFunkyStuff()
      }
    HStackNode {
      ButtonNode(key: Const.increaseButtonKey)
        .text("TAP HERE TO INCREASE COUNT")
        .font(UIFont.systemFont(ofSize: 12, weight: .bold))
        .setTarget(coordinator, action: #selector(CounterCoordinator.increase), for: .touchUpInside)
        .background(.systemTeal)
        .padding(Const.margin * 2)
        .cornerRadius(Const.cornerRadius)
      NilNode()
    }
  }
  .alignItems(.center)
  .matchHostingViewWidth(withMargin: 0)
  .withCoordinator(coordinator.descriptor())
}

// MARK: - Coordinator

class CounterState: State {
  var count: UInt = 0
  var isRotated: Bool = false
}

class CounterCoordinator: Coordinator<CounterState, NullProps> {
  @objc dynamic func increase() {
    state.count += 1
    body?.setNeedsReconcile()
  }

  // Example of manual access to the underlying view hierarchy.
  func doSomeFunkyStuff() {
    guard let body = body, let view = body.root.view(withKey: Const.increaseButtonKey) else {
      return
    }
    let transform = state.isRotated
      ? CGAffineTransform.identity
      : CGAffineTransform.init(rotationAngle: .pi)
    state.isRotated.toggle()
    UIView.animate(withDuration: 1) {
      view.transform = transform
    }
  }
}

// MARK: - Constants

struct Const {
  static let increaseButtonKey = "button_increase"
  static let size: CGFloat = 48.0
  static let cornerRadius: CGFloat = 8.0
  static let margin: CGFloat = 4.0
}
