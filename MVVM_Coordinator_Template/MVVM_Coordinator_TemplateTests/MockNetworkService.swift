//
//  MockNetworkService.swift
//  MyTMDBTests
//
//  Created by Bo Zhang on 2024-01-18.
//

import UIKit
@testable import MVVM_Coordinator_Template

class MockNetworkService: Networkable {
    
    var movie: MovieClient!
    var image: ImageClient!
    
    init() {
        self.movie = MockMovieClient(networkService: self)
        self.image = MockImageClient(networkService: self)
    }
    
    
    var mockMovieListResult: Result<MovieListResponse, MTError>?
    var mockMovieDetailResult: Result<MovieDetail, MTError>?
    
    var mockImageResult: UIImage?
    
    var requestResult: Result<Decodable, MTError>?
    func request<T>(endpoint: EndPointType) async throws -> T where T : Decodable {
        switch requestResult {
        case .success(let success):
            return success as! T
        case .failure(let failure):
            throw failure
        case nil:
            fatalError("need to set up mock result first")
        }
    }
    
    var requestImageResult: UIImage?
    func requestImage(from imageEndpoint: ImageEndPointType) async -> UIImage? {
        return requestImageResult
    }
}

class MockMovieClient: MovieClient {
    private unowned let networkService: MockNetworkService
    
    init(networkService: MockNetworkService) {
        self.networkService = networkService
    }
    
    
    func getNowPlaying(page: Int) async throws -> MovieListResponse {
        switch networkService.mockMovieListResult {
        case .success(let movieListResponse):
            return movieListResponse
        case .failure(let failure):
            throw failure
        case nil:
            fatalError("need to set up mock result first")
        }
    }
    
    func getPopular(page: Int) async throws -> MovieListResponse {
        switch networkService.mockMovieListResult {
        case .success(let movieListResponse):
            return movieListResponse
        case .failure(let failure):
            throw failure
        case nil:
            fatalError("need to set up mock result first")
        }
    }
    
    func getUpcoming(page: Int) async throws -> MovieListResponse {
        switch networkService.mockMovieListResult {
        case .success(let movieListResponse):
            return movieListResponse
        case .failure(let failure):
            throw failure
        case nil:
            fatalError("need to set up mock result first")
        }
    }
    
    func getTopRated(page: Int) async throws -> MovieListResponse {
        switch networkService.mockMovieListResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        case nil:
            fatalError("need to set up mock result first")
        }
    }
    
    
    func getMovieDetail(movieId: Int) async throws -> MovieDetail {
        switch networkService.mockMovieDetailResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        case nil:
            fatalError("need to set up mock result first")
        }
    }
}

class MockImageClient: ImageClient {
    
    private unowned let networkService: MockNetworkService
    
    init(networkService: MockNetworkService) {
        self.networkService = networkService
    }
    
    func getImage(with path: String, imageSize: MVVM_Coordinator_Template.ImageSize) async -> UIImage? {
        return networkService.mockImageResult
    }
    
}
