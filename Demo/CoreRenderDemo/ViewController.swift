import UIKit
import CoreRender
import CoreRenderObjC

class ViewCoordinator: UIViewController {
  var hostingView: HostingView!
  let context = Context()
  var coordinator: CounterCoordinator {
    let coordinator = context.coordinatorProvider(type: CounterCoordinator.self, key: "demo")!.coordinator
    return coordinator as! CounterCoordinator
  }
  
  override func loadView() {
    hostingView = HostingView(context: context, with: [.useSafeAreaInsets]) { ctx in
      makeDemoWidget(ctx: ctx, coordinator: self.coordinator)
        .withCoordinatorType(
          CounterCoordinator.self, key: "demo", initialState: CounterState(), props: NullProps())
        .build()
    }
    self.view = hostingView
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    hostingView.setNeedsLayout()
  }
  
}
