//
//  MovieTableViewController.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-18.
//

import UIKit
import Combine
import SwiftUI

class MovieTableViewController: UIViewController {
    
    enum Section { case main }
    
    private var tableView: UITableView!
    
    @ObservedObject var viewModel: MovieTableViewModel
    
    private let input:  PassthroughSubject<MovieTableViewModel.Input, Never> = .init()
    
    private var subscriptions = Set<AnyCancellable>()
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Movie> = makeDataSource()
    
    init(viewModel: MovieTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Movie Table"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBind()
        configureTableView()
        input.send(.requestMovieList(page: 1))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBind() {
        viewModel.bindToViewModel(input: input.eraseToAnyPublisher())
        viewModel.bindToViewController().sink { [weak self] event in
            switch event {
            case .getMovieListDidSucceed:
                self?.updateData(on: self?.viewModel.movies ?? [], withAnimation: self?.viewModel.currentPage == 1 ? false : true)
            case .loadingData(let isLoading):
                self?.handleIsLoading(with: isLoading)
            case .handleError(let error):
                self?.handleError(error: error)
            }
        }.store(in: &subscriptions)
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseID)
        
        view.addSubview(tableView)
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Movie> {
        let dataSource = UITableViewDiffableDataSource<Section, Movie>(tableView: tableView) { [unowned self] tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseID) as! MovieTableViewCell
            cell.setupView(networkService: self.viewModel.networkService, movie: movie)
            return cell
        }
        return dataSource
    }
    
    private func updateData(on movies: [Movie], withAnimation: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies, toSection: .main)
        
        let footerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        footerView.contentConfiguration = UIHostingConfiguration(content: {
            MoviesTableFooterView(currentPage: self.viewModel.currentPage, totalPage: self.viewModel.totalPage ?? 0)
 
        })
        
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: withAnimation)
            self?.tableView.tableFooterView = footerView
        }
    }
    
    func handleError(error: MTError) {
        
    }
    
    func handleIsLoading(with isLoading: Bool) {
        
    }
}

extension MovieTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        let movie = viewModel.movies[indexPath.item]
        openFlow(AppFlow.movieTable(.movieDetail(movieId: movie.id)).boxed, sender: self)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if currentOffset - maximumOffset >= 150 {
            input.send(.requestMovieList(page: viewModel.currentPage + 1))
        }
    }
}
