import UIKit
import CoreRender

// MARK: - ViewController

class CounterViewController: UIViewController {
  private var nodeHierarchy: NodeHierarchy?
  private let context = Context()

  override func viewDidLoad() {
    super.viewDidLoad()
    nodeHierarchy = NodeHierarchy(context: context) { ctx in
      counterNode(ctx: ctx)
    }
    // Do any additional setup after loading the view, typically from a nib.
    nodeHierarchy?.rebuild(in: view, constrainedTo: view.bounds.size, with: [.useSafeAreaInsets])
  }

  override func viewDidLayoutSubviews() {
    nodeHierarchy?.setNeedsLayout()
  }
}

// MARK: - CoreRender.Controller

class CounterController: Controller<NullProps, CounterState> {
  @objc dynamic func incrementCounter() {
    self.state.count += 1
    print("count: \(self.state.count)")
    nodeHierarchy?.setNeedsReconcile()
  }
}

// MARK: - CoreRender.State

class CounterState: State {
  var count = 0;
}
