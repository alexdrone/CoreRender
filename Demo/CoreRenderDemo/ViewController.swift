import UIKit
import CoreRender
import CoreRenderObjC

class ViewCoordinator: UIViewController {
  var hostingView: HostingView!
  let context = Context()
  var coordinator: CounterCoordinator {
    context.coordinator(CounterCoordinator.self)
  }
  
  override func loadView() {
    hostingView = HostingView(context: context, with: [.useSafeAreaInsets]) { ctx in
      makeDemoWidget(ctx: ctx, coordinator: self.coordinator).build()
    }
    self.view = hostingView
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    hostingView.setNeedsLayout()
  }
  
}
