import Foundation
import CoreRender

// MARK: - CoreRender.Node

func counterNode(ctx: Context) -> ConcreteNode<UIView> {
  let provider = ControllerProvider(ctx, type: CounterController.self, key: "counter_root")
  return makeNode(type: UIView.self)
    .withController(provider.controller)
    .withInitialState(CounterState())
    .withLayoutSpec { spec in
      set(spec, keyPath: \UIView.yoga.width, value: spec.size.width)
      set(spec, keyPath: \UIView.backgroundColor, value: .lightGray)
      set(spec, keyPath: \UIView.cornerRadius, value: 5)
    }.withChildren([
      makeNode(type: UIButton.self)
        .withReuseIdentifier("button")
        .withLayoutSpec { spec in
          let controller = provider.controller
          spec.view?.cr_resetAllTargets()
          spec.view?.addTarget(
            controller,
            action: #selector(CounterController.incrementCounter),
            for: .touchUpInside)
          spec.view?.setTitle("Count: \(controller.state.count)", for: .normal)
        }.build(),
  ]).build()
}
