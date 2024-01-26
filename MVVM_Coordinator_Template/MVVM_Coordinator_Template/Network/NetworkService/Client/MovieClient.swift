//
//  MovieClient.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-05.
//

import Foundation

protocol MovieClient {
    
    func getNowPlaying(page: Int) async throws  -> MovieListResponse
    func getPopular(page: Int) async throws  -> MovieListResponse
    func getUpcoming(page: Int) async throws  -> MovieListResponse
    func getTopRated(page: Int) async throws  -> MovieListResponse
    
    func getMovieDetail(movieId: Int) async throws -> MovieDetail
}

class ApiMovieClient: MovieClient {
    
    private unowned let networkService: Networkable
    
    init(networkService: Networkable) {
        self.networkService = networkService
    }
    
    func getNowPlaying(page: Int) async throws  -> MovieListResponse {
        return try await networkService.request(endpoint: MovieListEndPoint.nowPlaying(page: page))
    }
    
    func getPopular(page: Int) async throws  -> MovieListResponse {
        return try await networkService.request(endpoint: MovieListEndPoint.popular(page: page))
    }
    
    func getUpcoming(page: Int) async throws  -> MovieListResponse {
        return try await networkService.request(endpoint: MovieListEndPoint.upcoming(page: page))
    }
    
    func getTopRated(page: Int) async throws  -> MovieListResponse {
        return try await networkService.request(endpoint: MovieListEndPoint.topRated(page: page))
    }
    
    func getMovieDetail(movieId: Int) async throws -> MovieDetail {
        return try await networkService.request(endpoint: MovieDetailEndPoint.movieDetail(movieId: movieId))
    }
}

