import UIKit
import CoreRender
import CoreRenderObjC

class ViewCoordinator: UIViewController {
  var hostingView: HostingView!
  let context = Context()
  
  override func loadView() {
    hostingView = HostingView(context: context, with: [.useSafeAreaInsets]) { ctx in
      makeDemoWidget(ctx: ctx)
    }
    self.view = hostingView
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    hostingView.setNeedsLayout()
  }

  
}
