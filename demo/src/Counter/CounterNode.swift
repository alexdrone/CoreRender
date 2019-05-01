import Foundation
import CoreRender

// MARK: - CoreRender.Node

func mainNode(ctx: Context) -> ConcreteNode<UIView> {
  var nodes: [AnyNode] = []
  for idx in 0...100 {
    nodes.append(counterNode(ctx: ctx, key: "counter-\(idx)"))
  }
  let scrollView = scrollNode(ctx: ctx, children: nodes)
  return ctx.makeNode(type: UIView.self)
    .withLayoutSpec { spec in
      ctx.set(spec, keyPath: \.yoga.width, value: spec.size.width)
      ctx.set(spec, keyPath: \.yoga.height, value: spec.size.height)
    }.withChildren([scrollView]).build()
}

func scrollNode(ctx: Context, children: [AnyNode]) -> ConcreteNode<UIScrollView> {
  return ctx.makeNode(type: UIScrollView.self)
    .withLayoutSpec { spec in
      ctx.set(spec, keyPath: \.backgroundColor, value: Theme.palette.light)
      ctx.set(spec, keyPath: \.yoga.width, value: spec.size.width)
      ctx.set(spec, keyPath: \.yoga.height, value: spec.size.height)
    }.withChildren(children).build()
}

func counterNode(ctx: Context, key: String) -> ConcreteNode<UIView> {
  // Retrieve the root node controller.
  let controllerProvider = ctx.controllerProvider(
    type: CounterController.self,
    key: key)
  // Returns the node hiearchy.
  return ctx.makeNode(type: UIView.self)
    .withControllerType(
      CounterController.self,
      key: key,
      initialState: CounterState(),
      props: NullProps.null)
    .withLayoutSpec { spec in
      ctx.set(spec, keyPath: \.backgroundColor, value: Theme.palette.surface)
      ctx.set(spec, keyPath: \.layer.cornerRadius, value: 8)
      ctx.set(spec, keyPath: \.yoga.margin, value: 12)
      ctx.set(spec, keyPath: \.yoga.padding, value: 32)
      ctx.set(spec, keyPath: \.yoga.alignItems, value: .center)
      ctx.set(spec, keyPath: \.yoga.justifyContent, value: .center)
    }.withChildren([
      ctx.makeNode(type: Label.self)
        .withReuseIdentifier("title")
        .withLayoutSpec { spec in
          guard let view = spec.view else { return }
          view.style = Typography.Style.subtitle1
          view.text = "CoreRender"
          view.yoga.margin = 4
        }.build(),
      ctx.makeNode(type: Label.self)
        .withReuseIdentifier("desc")
        .withLayoutSpec { spec in
          guard let view = spec.view else { return }
          let count = controllerProvider?.controller.state.count ?? 0
          ctx.set(spec, keyPath: \.text, value: "{key: \(key), count: \(count)}")
          ctx.set(spec, keyPath: \.yoga.margin, value:8)
          // View properties can be set also by directing access to the view through spec.view?
          view.style = Typography.Style.caption
        }.build(),
      ctx.makeNode(type: Button.self)
        .withViewInit { _ in
          let button = Button(
            style: .secondary,
            title: "Increase count",
            raised: true)
          button.addTarget(
            controllerProvider?.controller,
            action: #selector(CounterController.incrementCounter),
            for: .touchUpInside)
          return button
        }.withReuseIdentifier("button").build(),
  ]).build()
}
