//
//  MainCoordinator.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-12.
//

import UIKit

enum AppFlow {
    case movie(MovieScreen)
    case movieTable(MovieTableScreen)
    case orders(OrdersScreen)
}

///    ObjC wrapper for `AppFlow`  to faciliate usage of non-ObjC types as arguments for ObjC methods.
final class AppFlowBox: NSObject {
    let unbox: AppFlow
    init(_ value: AppFlow) {
        self.unbox = value
    }
}
extension AppFlow {
    var boxed: AppFlowBox { return AppFlowBox(self) }
}


class MainCoordinator: Coordinator<UITabBarController> {
    
    let networkService: Networkable = NetworkService()
    
    override func start() async {
        await super.start()
        await setupTabs()
    }
    
    override func openFlow(_ flowBoxed: AppFlowBox, keepHierarchy: Bool = false, userData: [String : Any]? = nil, sender: Any?) {
        let flow = flowBoxed.unbox
        
        switch flow {
        case .movie(let movieScreen):
            guard let c = childCoordinators.child(matching: MoviesCoordinator.self) else { return }
            c.displayScreen(movieScreen)
            rootViewController.selectedIndex = 0
        case .movieTable(let movieTableScreen):
            guard let c = childCoordinators.child(matching: MovieTableCoordinator.self) else { return }
            c.displayScreen(movieTableScreen)
            rootViewController.selectedIndex = 1
            
        case .orders(let ordersScreen):
            guard let c = childCoordinators.child(matching: OrdersCoordinator.self) else { return }
            c.displayScreen(ordersScreen, userData: userData, sender: sender)
            rootViewController.selectedIndex = 2
        }
    }
}

private extension MainCoordinator {
    func setupTabs() async {
        
        let movieCoordinator = MoviesCoordinator(networkService: networkService)
        await startChild(coordinator: movieCoordinator)
        movieCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "homekit"), tag: 0)
        
        let movieTableCoordinator = MovieTableCoordinator(networkService: networkService)
        await startChild(coordinator: movieTableCoordinator)
        movieTableCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Table", image: UIImage(systemName: "movieclapper"), tag: 1)
        
        let oc = OrdersCoordinator()
        await startChild(coordinator: oc)
        oc.rootViewController.tabBarItem = UITabBarItem(title: "Orders", image: UIImage(systemName: "doc.plaintext"), tag: 2)
        
        rootViewController.viewControllers = [
            movieCoordinator.rootViewController,
            movieTableCoordinator.rootViewController,
            oc.rootViewController
        ]
    }
}
