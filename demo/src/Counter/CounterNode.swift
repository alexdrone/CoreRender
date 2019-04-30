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
      ctx.set(spec, keyPath: \UIScrollView.yoga.width, value: spec.size.width)
      ctx.set(spec, keyPath: \UIScrollView.yoga.height, value: spec.size.height)
    }.withChildren([scrollView]).build()
}

func scrollNode(ctx: Context, children: [AnyNode]) -> ConcreteNode<UIScrollView> {
  return ctx.makeNode(type: UIScrollView.self)
    .withLayoutSpec { spec in
      ctx.set(spec, keyPath: \UIScrollView.backgroundColor, value: Theme.palette.light)
      ctx.set(spec, keyPath: \UIScrollView.yoga.width, value: spec.size.width)
      ctx.set(spec, keyPath: \UIScrollView.yoga.height, value: spec.size.height)
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
      guard let view = spec.view else { return }
      view.backgroundColor = Theme.palette.surface
      view.layer.cornerRadius = 8
      view.yoga.margin = 12
      view.yoga.padding = 32
      view.yoga.alignItems = .center
      view.yoga.justifyContent = .center
      view.depthPreset = .depth1
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
          view.style = Typography.Style.caption
          let count = controllerProvider?.controller.state.count ?? 0
          view.text = "{key: \(key), count: \(count)}"
          view.yoga.margin = 8
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
