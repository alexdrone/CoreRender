import Foundation
import CoreRender
import CoreRenderObjC

struct DemoWidget {
  
  static func makeComponent(ctx: Context) -> OpaqueNodeBuilder {
    Component(type: DemoWidget.Coordinator.self, context: ctx) { ctx, coordinator in
      makeBody(ctx: ctx, coordinator: coordinator)
    }
  }

  static func makeBody(ctx: Context, coordinator: DemoWidget.Coordinator) -> OpaqueNodeBuilder {
    VStackNode {
      LabelNode(text: "\(coordinator.count)")
        //.font(UIFont.systemFont(ofSize: 24, weight: .black))
        .textAlignment(.center)
        .textColor(.darkText)
        .background(.secondarySystemBackground)
        .width(Const.size + 8 * CGFloat(coordinator.count))
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
          .setTarget(
            coordinator, action: #selector(DemoWidget.Coordinator.increase), for: .touchUpInside)
          .background(.systemTeal)
          .padding(Const.margin * 2)
          .cornerRadius(Const.cornerRadius)
        SpacerNode()
      }
    }
    .alignItems(.center)
    .matchHostingViewWidth(withMargin: 0)
  }

  class Coordinator: CoreRenderObjC.Coordinator {
    var count: UInt = 0
    var isRotated: Bool = false

    @objc dynamic func increase() {
      count += 1
      body?.setNeedsReconcile()
    }

    // Example of manual access to the underlying view hierarchy.
    // Transitions can be performed in the node description as well, this is just an
    // example of manual view hierarchy manipulation.
    func doSomeFunkyStuff() {
      guard let body = body, let view = body.root.view(withKey: Const.increaseButtonKey) else {
        return
      }
      let transform = isRotated
        ? CGAffineTransform.identity
        : CGAffineTransform.init(rotationAngle: .pi)
      isRotated.toggle()
      UIView.animate(withDuration: 1) {
        view.transform = transform
      }
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
