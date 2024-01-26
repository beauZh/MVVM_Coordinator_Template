//
//  MovieListViewController.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-09.
//

import UIKit
import SwiftUI
import Combine

class MovieListViewController: UIViewController {
    
    enum Section { case main }
    
    private var collectionView: UICollectionView!
    
    var viewModel: MovieListViewModelProtocol!
    
    private let input:  PassthroughSubject<MovieListViewModel.Input, Never> = .init()
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Movie> = makeDataSource()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "Movie List"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBind()
        configureCollectionView()
        input.send(.requestMovieList(page: 1))
    }
    
    private func configureBind() {
        viewModel.bindToViewModel(input: input.eraseToAnyPublisher())
        viewModel.bindToViewController().sink { [weak self] event in
            switch event {
            case .getMovieListDidSucceed(let movies, let currentPage, _):
                self?.updateData(on: movies, withAnimation: currentPage == 1 ? false : true)
            case .loadingData(let isLoading):
                self?.handleLoading(isLoading: isLoading)
            case .handleError(let error):
                self?.handleError(error: error)
            }
        }.store(in: &subscriptions)
    }
    
    func configureCollectionView() {
        let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let fraction: CGFloat = 1 / 3
            let inset: CGFloat = 2.5

            // Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(fraction),
                heightDimension: .estimated(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(100)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            group.interItemSpacing = .fixed(0)

            // Section
            let section = NSCollectionLayoutSection(group: group)
//            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(
                top: inset,
                leading: inset,
                bottom: inset,
                trailing: inset
            )

            // Supplementary Item (Footer)
            let footerItemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(100),
                heightDimension: .estimated(50)
            )
            let footerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerItemSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
            
            section.boundarySupplementaryItems = [footerItem]

            return section
        })
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositionalLayout)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        view.addSubview(collectionView)
    }
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Movie> {
        let movieListCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Movie> { [weak self] cell, indexPath, item in
            
            cell.contentConfiguration = UIHostingConfiguration(content: {
                MovieListCellView(vm: MovieListCellViewModel(networkService: self?.viewModel.networkService, movie: item))
            })
        }
        
        let movieListFooterRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewCell>(elementKind: UICollectionView.elementKindSectionFooter) { [unowned self] footer, elementKind, indexPath in
            footer.contentConfiguration = UIHostingConfiguration(content: {
                MovieListFooterView(viewModel: self.viewModel as! MovieListViewModel)
            })
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView) { collectionView, indexPath, movie in
            let cell = collectionView.dequeueConfiguredReusableCell(using: movieListCellRegistration, for: indexPath, item: movie)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionFooter {
                return collectionView.dequeueConfiguredReusableSupplementary(using: movieListFooterRegistration, for: indexPath)
            }
            return nil
        }
        return dataSource
    }
    
    private func updateData(on movies: [Movie], withAnimation: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies, toSection: .main)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: withAnimation)
        }
    }
    
    private func handleLoading(isLoading: Bool) {
        
    }
    
    private func handleError(error: MTError) {
        
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.item]
        openFlow(AppFlow.movie(.movieDetail(movieId: movie.id)).boxed, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter, viewModel.currentPage < viewModel.totalPages ?? 0 {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.input.send(.requestMovieList(page: self.viewModel.currentPage + 1))
            }
        }
    }
}
