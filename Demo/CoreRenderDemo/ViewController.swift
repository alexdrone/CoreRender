import UIKit
import CoreRender
import CoreRenderObjC

class ViewCoordinator: UIViewController {
  var hostingView: HostingView!
  let context = Context()
  var coordinator: CounterCoordinator {
    let c = context.coordinator(CounterCoordinator.descriptor.toRef())
    guard let _ = c as? CounterCoordinator else {
      print(type(of: c))
      let a =  CounterCoordinator
      print(type(of: a))
      print(c is CounterCoordinator)
      print(c is CoordinatorProtocol)
      print(c.state)
      fatalError()
    }
    return coordinator
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
