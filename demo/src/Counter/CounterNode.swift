import Foundation
import CoreRender

// MARK: - CoreRender.Node

func counterNode(ctx: Context) -> ConcreteNode<UIView> {
  struct Key {
    static let counterRoot = "counterRoot"
  }
  // Retrieve the root node controller.
  let controllerProvider = ctx.controllerProvider(
    type: CounterController.self,
    key: Key.counterRoot)
  // Returns the node hiearchy.
  return ctx.makeNode(type: UIView.self)
    .withControllerType(
      CounterController.self,
      key: Key.counterRoot,
      initialState: CounterState(),
      props: NullProps.null)
    .withLayoutSpec { spec in
      ctx.set(spec, keyPath: \UIView.yoga.width, value: spec.size.width)
      ctx.set(spec, keyPath: \UIView.backgroundColor, value: .lightGray)
      ctx.set(spec, keyPath: \UIView.cornerRadius, value: 5)
    }.withChildren([
      ctx.makeNode(type: UIButton.self)
        .withViewInit { _ in
          let button = UIButton()
          button.addTarget(
            controllerProvider?.controller,
            action: #selector(CounterController.incrementCounter),
            for: .touchUpInside)
          return button
        }.withReuseIdentifier("button")
        .withLayoutSpec { spec in
          let count = controllerProvider?.controller.state.count ?? 0
          spec.view?.setTitle("Count: \(count)", for: .normal)
        }.build(),
  ]).build()
}
