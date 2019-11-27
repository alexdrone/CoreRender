# CoreRender [![Swift](https://img.shields.io/badge/swift-5.1-orange.svg?style=flat)](#) [![ObjC++](https://img.shields.io/badge/ObjC++-blue.svg?style=flat)](#) [![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://opensource.org/licenses/MIT)

<img src="docs/assets/logo_new.png" width=150 alt="CoreRender" align=right />

CoreRender is a SwiftUI inspired API for UIKit (that is compatible with iOS 10+ and ObjC).


### Introduction

* **Declarative:** CoreRender uses a declarative API to define UI components. You simply describe the layout for your UI based on a set of inputs and the framework takes care of the rest (*diff* and *reconciliation* from virtual view hierarchy to the actual one under the hood).
* **Flexbox layout:** CoreRender includes the robust and battle-tested Facebook's [Yoga](https://facebook.github.io/yoga/) as default layout engine.
* **Fine-grained recycling:** Any component such as a text or image can be recycled and reused anywhere in the UI.

### TL;DR

Let's build the classic *Counter-Example*.

The following is the node hierarchy definition.

```swift
func makeCounterWidget(context: Context, coordinator: CounterCoordinator) -> NodeBuilder<UIView> {
  VStack {
    Label(text: "\(coordinator.state.count)")
      .textColor(.darkText)
      .background(.secondarySystemBackground)
      .width(Const.size + 8 * CGFloat(coordinator.state.count))
      .height(Const.size)
      .margin(Const.margin)
      .cornerRadius(Const.cornerRadius)
    HStack {
      Button()
        .text("TAP HERE TO INCREASE COUNT")
        .setTarget(coordinator, action: #selector(CounterCoordinator.increase), for: .touchUpInside)
        .background(.systemTeal)
        .padding(Const.margin * 2)
        .cornerRadius(Const.cornerRadius)
    }
  }
  .alignItems(.center)
  .matchHostingViewWidth(withMargin: 0)
}
```

<img src="docs/assets/screen_2.png" width=320 alt="screen" />

`Label` and `Button` are just specialized versions of the `Node<V: UIView>` pure function.
That means you could wrap any UIView subclass in a vdom node. e.g.
```swift

Node(UIScrollView.self) {
  Node(UILabel.self).withLayoutSpec { spec in 
    // This is where you can have all sort of custom view configuration.
  }
  Node(UISwitch.self)
}

```
The `withLayoutSpec` modifier allows to specify a custom configuration closure for your view.



*Coordinators* are similar to Components in React/Render/Litho and Coordinators in SwiftUI.

```swift
class CounterCoordinator: Coordinator{
  var count: UInt = 0

  func incrementCounter() {
    self.state.count += 1                // Update the state.
    body?.setNeedsReconcile()            // Trigger the reconciliation algorithm on the view hiearchy associated to this coordinator.
  }
}
```

Finally let's create *CoreRender* node hiararchy in our ViewCoordinator.

```swift
class CounterViewCoordinator: UIViewController {
  var hostingView: HostingView!
  let context = Context()

  override func loadView() {
    hostingView = HostingView(context: context, with: [.useSafeAreaInsets]) { context in
      Component<CounterCoordinator>(context: context) { context, coordinator in
        makeCounterWidget(context: context, coordinator: coordinator)
      }.builder()
    }
    self.view = hostingView
  }
    
  override func viewDidLayoutSubviews() {
    hostingView.setNeedsLayout()
  }
}
```
