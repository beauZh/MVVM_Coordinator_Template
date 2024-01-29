//
//  MovieListViewModel.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-09.
//

import Foundation
import Combine

//protocol MovieListViewModelProtocol: AnyObject {
//    
//    var networkService: Networkable { get }
//    
//    var movies: [Movie] { get set }
//    var currentPage: Int { get set }
//    var totalPages: Int? { get set }
//    
//    func bindToViewModel(input: AnyPublisher<MovieListViewModel.Input, Never>)
//    func bindToViewController() -> AnyPublisher<MovieListViewModel.Output, Never>
//    
//    func handleGetMovieResponse(page: Int)
//}

@MainActor
class MovieListViewModel: ObservableObject {
    
    enum Input {
        case viewDidAppear
        case infoButtonDidTap
        case requestMovieList(page: Int)
    }
    
    enum Output {
        case getMovieListDidSucceed(movies: [Movie], currentPage: Int, totalPages: Int?)
        case loadingData(isLoading: Bool)
        case handleError(error: MTError)
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var subscriptions = Set<AnyCancellable>()
    
    var networkService: Networkable
    
    @Published var movies: [Movie] = []
    @Published var currentPage: Int = 1
    @Published var totalPages: Int?
    
    init(networkService: Networkable) {
        self.networkService = networkService
    }
    
    func bindToViewModel(input: AnyPublisher<Input, Never>) {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear:
                print("view did appear")
            case .infoButtonDidTap:
                print("infoButtonDidTap")
            case .requestMovieList(let page):
                self?.handleGetMovieResponse(page: page)
            }
        }.store(in: &subscriptions)
    }
    
    func bindToViewController() -> AnyPublisher<Output, Never> {
        return output.eraseToAnyPublisher()
    }
    
    func handleGetMovieResponse(page: Int) {
        Task {
            do {
                output.send(.loadingData(isLoading: true))
                
                let movieResponse = try await networkService.movie.getNowPlaying(page: page)
                    
                currentPage = movieResponse.page
                totalPages = movieResponse.totalPages
                if movieResponse.page == 1 {
                    movies = movieResponse.results
                } else {
                    movieResponse.results.forEach { movie in
                        if !movies.map({$0.id}).contains(movie.id) {
                            movies.append(movie)
                        }
                    }
                }
                output.send(.loadingData(isLoading: false))
                output.send(.getMovieListDidSucceed(movies: self.movies, currentPage: self.currentPage, totalPages: self.totalPages))
            } catch {
                output.send(.loadingData(isLoading: false))
                output.send(.handleError(error: MTError.convert(error: error)))
            }
        }
    }
}
