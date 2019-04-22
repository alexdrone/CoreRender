# CoreRender [![Swift](https://img.shields.io/badge/swift-5-orange.svg?style=flat)](#) [![ObjC++](https://img.shields.io/badge/ObjC++-blue.svg?style=flat)](#) [![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](#) [![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://opensource.org/licenses/MIT)

<img src="docs/assets/logo_new.png" width=150 alt="Render" align=right />

CoreRender is an ObjC++ *(Swift compatible)* minimal and performance-oriented implementation of [Render](https://github.com/alexdrone/Render).

### Introduction

* **Declarative:** CoreRender uses a declarative API to define UI components. You simply describe the layout for your UI based on a set of inputs and the framework takes care of the rest (*diff* and *reconciliation* from virtual view hierarchy to the actual one under the hood).
* **Flexbox layout:** CoreRender includes the robust and battle-tested Facebook's [Yoga](https://facebook.github.io/yoga/) as default layout engine.
* **Fine-grained recycling:** Any component such as a text or image can be recycled and reused anywhere in the UI.

### Installing the framework

```bash
cd {PROJECT_ROOT_DIRECTORY}
curl "https://raw.githubusercontent.com/alexdrone/CoreRender/master/bin/dist.zip" > dist.zip && unzip dist.zip && rm dist.zip;
```

Drag `CoreRender.framework` in your project and add it as an embedded binary.

If you use [xcodegen](https://github.com/yonaskolb/XcodeGen) add the framework to your *project.yml* like so:

```yaml
targets:
  YOUR_APP_TARGET:
    ...
    dependencies:
      - framework: PATH/TO/YOUR/DEPS/CoreRender.framework
```

### TL;DR

Let's build the classic *Counter-Example*.

The following is the node hierarchy definition. 

```swift
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
```

*Controllers* are similar to Components in React/Render/Litho and manage the UI updates. 

```swift
class CounterController: Controller<NullProps, CounterState> {
  
  func incrementCounter() {
    self.state.count += 1
    print("count: \(self.state.count)")
    nodeHierarchy?.setNeedsReconcile()
  }
}

class CounterState: State {
  var count = 0;
}
```

Finally let's create *CoreRender* node hiararchy in our ViewController.

```swift
class CounterViewController: UIViewController {
  private var nodeHierarchy: NodeHierarchy?
  private let context = Context()

  override func viewDidLoad() {
    super.viewDidLoad()
    nodeHierarchy = NodeHierarchy(context: context) { ctx in
      counterNode(ctx: ctx)
    }
    nodeHierarchy?.build(in: view, constrainedTo: view.bounds.size, with: [.useSafeAreaInsets])
  }

  override func viewDidLayoutSubviews() {
    nodeHierarchy?.setNeedsLayout()
  }
}
```
