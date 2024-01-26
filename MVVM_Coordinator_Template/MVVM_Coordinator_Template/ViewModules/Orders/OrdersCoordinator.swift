import UIKit

enum OrdersScreen {
	case firstScreen
	case secondScreen
	case thirdScreen
}

class OrdersCoordinator: NavigationCoordinator {
	required init() {
		let nc = UINavigationController()
		super.init(rootViewController: nc)
	}
    
    override func start() async {
        await super.start()
        setupInitialContent()
    }
    
    override func openFlow(_ flowboxed: AppFlowBox, keepHierarchy: Bool = false, userData: [String : Any]? = nil, sender: Any?) {
        let flow = flowboxed.unbox
        
        switch flow {
        case .movie:
            coordinatingResponder?.openFlow(flowboxed, userData: userData, sender: sender)
        case .movieTable(_):
            coordinatingResponder?.openFlow(flowboxed, sender: sender)
        case .orders(let screen):
            displayScreen(screen, userData: userData, sender: sender)
        }
    }
    

	func displayScreen(_ screen: OrdersScreen, userData: [String: Any]? = nil, sender: Any? = nil) {
		switch screen {
			case .firstScreen:
				if let vc = viewControllers.first(where: { $0 is OrdersViewController }) {
					pop(to: vc)
					return
				}
				let vc = prepareFirstScreen()
				root(vc)

			case .secondScreen:
				if let vc = viewControllers.first(where: { $0 is Orders2ViewController }) {
					pop(to: vc)
					return
				}
				let vc = prepareSecondScreen()
				show(vc)

            case .thirdScreen:
            if let vc = viewControllers.first(where: { $0 is Orders3ViewController }) {
                pop(to: vc)
                return
            }
            
            
            viewControllers = [
                prepareFirstScreen(),
                prepareSecondScreen(),
                prepareThirdScreen()
            ]
            rootViewController.viewControllers = viewControllers
            
            if let vc = viewControllers.first(where: { $0 is Orders3ViewController }) {
                pop(to: vc)
            }
		}
	}

    func resetToRoot(){
		displayScreen(.firstScreen)
    }
    
}

private extension OrdersCoordinator {
	func setupInitialContent() {
		rootViewController.viewControllers = [
			prepareFirstScreen()
		]
		
		viewControllers = rootViewController.viewControllers
	}

	func prepareFirstScreen() -> OrdersViewController {
		let vc = OrdersViewController()
		return vc
	}

	func prepareSecondScreen() -> Orders2ViewController {
		let vc = Orders2ViewController()
		return vc
	}

	func prepareThirdScreen() -> Orders3ViewController {
		let vc = Orders3ViewController()
		return vc
	}
}
