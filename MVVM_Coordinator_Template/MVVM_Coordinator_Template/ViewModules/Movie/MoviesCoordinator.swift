//
//  MoviesCoordinator.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-12.
//

import UIKit
import SwiftUI

enum MovieScreen {
    case movieList
    case movieDetail(movieId: Int)
}

class MoviesCoordinator: NavigationCoordinator {
    
    let networkService: Networkable
    
    required init(networkService: Networkable) {
        self.networkService = networkService
        
        let navigationController = UINavigationController()
        super.init(rootViewController: navigationController)
    }
    
    override func start() async {
        await super.start()
        setupInitialContent()
    }
    
    override func openFlow(_ flowboxed: AppFlowBox, keepHierarchy: Bool = false, userData: [String : Any]? = nil, sender: Any?) {
        let flow = flowboxed.unbox
        
        switch flow {
        case .movie(let movieScreen):
            displayScreen(movieScreen)
        case .movieTable:
            coordinatingResponder?.openFlow(flowboxed, sender: sender)
        case .orders:
            coordinatingResponder?.openFlow(flowboxed, sender: sender)
        }
    }
    
    func displayScreen(_ screen: MovieScreen, userData: [String: Any]? = nil, sender: Any? = nil) {
        switch screen {
        case .movieList:
            if let vc = viewControllers.first(where:  {$0 is MovieListViewController}) {
                pop(to: vc)
                return
            }
            
            let vc = prepareMovieListScreen()
            root(vc)
        case .movieDetail(let movieId):
            if let vc = viewControllers.first(where:  { $0 is UIHostingController<MovieDetaiView> }) {
                pop(to: vc)
                return
            }
            
            let vc = prepareMovieDetailScreen(movieId: movieId)
            show(vc)
        }
    }
    
}

private extension MoviesCoordinator {
    
    func setupInitialContent() {
        rootViewController.viewControllers = [ prepareMovieListScreen() ]
        viewControllers = rootViewController.viewControllers
        rootViewController.navigationBar.prefersLargeTitles = true
    }
    
    func prepareMovieListScreen() -> MovieListViewController {
        let vc = MovieListViewController()
        vc.viewModel = MovieListViewModel(networkService: networkService)
        return vc
    }
    
    func prepareMovieDetailScreen(movieId: Int) -> UIHostingController<MovieDetaiView> {
        let hostingVCRefer = HostingVCRefer()
        let movieDetailView = MovieDetaiView(viewModel: MovieDetailViewModel(networkService: networkService, movieId: movieId), hostingVCRefer: hostingVCRefer)
        let vc = UIHostingController(rootView: movieDetailView)
        hostingVCRefer.hostingController = vc
        
        return vc
    }
}
