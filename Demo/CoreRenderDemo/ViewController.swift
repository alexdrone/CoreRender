import UIKit
import CoreRender
import CoreRenderObjC

class ViewController: UIViewController {
  var hostingView: HostingView!
  let context = Context()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    build()
  }
  
  override func viewDidLayoutSubviews() {
    build()
  }
  
  func build() {
    let node = makeDemoWidget(ctx: context)
    node.registerHierarchy(in: context)
    node.reconcile(in: self.view, constrainedTo: view.bounds.size, with: [])
    node.layoutConstrained(to: view.bounds.size, with: [])
    print(node)
  }
  
}
