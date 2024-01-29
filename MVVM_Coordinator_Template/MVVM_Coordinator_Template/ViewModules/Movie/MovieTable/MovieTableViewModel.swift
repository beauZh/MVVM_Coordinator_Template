//
//  MovieTableViewModel.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-18.
//

import Foundation
import Combine

@MainActor
class MovieTableViewModel: ObservableObject {
    
    enum Input {
        case viewDidAppear
        case requestMovieList(page: Int)
        
    }
    
    enum Output {
        case getMovieListDidSucceed
        case loadingData(isLoading: Bool)
        case handleError(error: MTError)
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var subscriptions = Set<AnyCancellable>()
    
    var networkService: Networkable
    
    var movies: [Movie] = []
    @Published var currentPage: Int = 1
    @Published var totalPage: Int?
    
    init(networkService: Networkable) {
        self.networkService = networkService
    }
    
    func bindToViewModel(input: AnyPublisher<Input, Never>) {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear:
                print("view did appear")
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
                let movieResponse = try await networkService.movie.getPopular(page: page)
                
                if page == 1 {
                    movies = movieResponse.results
                } else {
                    movieResponse.results.forEach { movie in
                        if !movies.map({$0.id}).contains(movie.id) {
                            movies.append(movie)
                        }
                    }
                }
                currentPage = movieResponse.page
                totalPage = movieResponse.totalPages
                output.send(.loadingData(isLoading: false))
                output.send(.getMovieListDidSucceed)
            } catch {
                output.send(.loadingData(isLoading: false))
                output.send(.handleError(error: MTError.convert(error: error)))
            }
        }
    }
}
