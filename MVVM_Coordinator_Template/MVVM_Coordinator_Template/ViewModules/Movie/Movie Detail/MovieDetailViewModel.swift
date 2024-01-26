//
//  MovieDetailViewModel.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-14.
//

import Foundation
import Combine

import CryptoKit

class MovieDetailViewModel: ObservableObject {
    
    @Published var movieDetail: MovieDetail?
    
    var networkService: Networkable
    var movieId: Int
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    init(networkService: Networkable, movieId: Int) {
        self.networkService = networkService
        self.movieId = movieId
        
        Task {
            await getMovieDetail(movieId: movieId )
        }
    }
    
    
    func getMovieDetail(movieId: Int) async {
        do {
//            let movieDetail = try await networkService.movie.getMovieDetail(movieId: movieId)
            let movieDetail: MovieDetail = try await networkService.request(endpoint: MovieDetailEndPoint.movieDetail(movieId: movieId))
            
            DispatchQueue.main.async { [weak self] in
                self?.movieDetail = movieDetail
            }
        } catch {
            //handle error
            print(error)
        }
    }
    
    
    
    
}
