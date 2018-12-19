import UIKit
import CoreRender

// MARK: - ViewController

class CounterViewController: UIViewController {
  private var node: ConcreteNode<UIView>?
  private let context = Context()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    render()
  }

  func render() {
    node = context.buildNodeHiearchy { ctx in
      counterNode(ctx: ctx)
    }
    node?.reconcile(in: view, constrainedTo: view.bounds.size, with: [.useSafeAreaInsets])
  }

  override func viewDidLayoutSubviews() {
    render()
  }
}

// MARK: - CoreRender.Controller

class CounterController: Controller<NullProps, CounterState> {
  @objc dynamic func incrementCounter() {
    self.state.count += 1
    print("count: \(self.state.count)")
    self.setNeedsReconcile()
  }
}

// MARK: - CoreRender.State

class CounterState: State {
  var count = 0;
}
