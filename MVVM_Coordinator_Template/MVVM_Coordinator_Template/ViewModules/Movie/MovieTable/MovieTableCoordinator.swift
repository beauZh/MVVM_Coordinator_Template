//
//  MovieTableCoordinator.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-19.
//

import Foundation

import UIKit
import SwiftUI

enum MovieTableScreen {
    case movieTable
    case movieDetail(movieId: Int)
}

class MovieTableCoordinator: NavigationCoordinator {
    
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
        case .movie:
            coordinatingResponder?.openFlow(flowboxed, sender: sender)
        case .movieTable(let movieTableScreen):
            displayScreen(movieTableScreen)
        case .orders:
            coordinatingResponder?.openFlow(flowboxed, sender: sender)
        }
    }
    
    func displayScreen(_ screen: MovieTableScreen, userData: [String: Any]? = nil, sender: Any? = nil) {
        switch screen {
        case .movieTable:
            if let vc = viewControllers.first(where:  {$0 is MovieTableViewController}) {
                pop(to: vc)
                return
            }
            
            let vc = prepareMovieTableScreen()
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

private extension MovieTableCoordinator {
    
    func setupInitialContent() {
        rootViewController.viewControllers = [
            prepareMovieTableScreen()
        ]
        viewControllers = rootViewController.viewControllers
        
        rootViewController.navigationBar.prefersLargeTitles = true
        
    }
    
    func prepareMovieTableScreen() -> MovieTableViewController {
        let vc = MovieTableViewController(viewModel: MovieTableViewModel(networkService: networkService))
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
