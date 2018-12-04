import Foundation
import CoreRender

// MARK: - CoreRender.Node

func counterNode(ctx: Context) -> ConcreteNode<UIView> {
  let controller = ctx.controller(ofType:  CounterController.self, withKey: "counter_root")
  let node = Node(type: UIView.self, controller: CounterController.self, key: "counter") { spec in
    set(spec, keyPath: \UIView.yoga.width, value: spec.size.width)
  }
  let wrapper = Node(type: UIView.self) { spec in
    set(spec, keyPath: \UIView.backgroundColor, value: .lightGray)
    set(spec, keyPath: \UIView.cornerRadius, value: 5)
    set(spec, keyPath: \UIView.yoga.margin, value: 20)
    set(spec, keyPath: \UIView.yoga.padding, value: 20)
  }
  let label = Node(type: UIButton.self) { spec in
    guard let controller = spec.controller(ofType: CounterController.self) else { return }
    guard let state = controller.state as? CounterState else { return }

    spec.resetAllTargets()
    spec.view?.setTitle("Count: \(state.count)", for: .normal)
    spec.view?.addTarget(
      controller,
      action: #selector(CounterController.incrementCounter),
      for: .touchUpInside)
  }


  node.append(children: [wrapper])
  wrapper.append(children: [label])

  return node
}
