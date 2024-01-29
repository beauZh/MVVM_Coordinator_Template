//
//  MVVM_Coordinator_TemplateTests.swift
//  MVVM_Coordinator_TemplateTests
//
//  Created by Bo Zhang on 2024-01-25.
//

import XCTest
import Combine
@testable import MVVM_Coordinator_Template

final class MVVM_Coordinator_TemplateTests: XCTestCase {
    
    private var sut: MovieListViewModel!
    private var networkService: MockNetworkService!
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func setUp() async throws {
        networkService = MockNetworkService()
        sut = await MovieListViewModel(networkService: networkService)
        try await super.setUp()
    }
    
    override func tearDown() async throws {
        sut = nil
        networkService = nil
        subscriptions = Set<AnyCancellable>()
        try await super.tearDown()
    }

    func test_handleGetMovieResponse_success() async {
        // given
        networkService.mockMovieListResult = .success(MovieListResponse.sample())
        var loadingDataCount = 0
        
        let getMovieListDidSucceedExpectation = expectation(description: "getMovieListDidSucceed")
        let loadingDataExpectation = expectation(description: "loadingData happens 2 times")
        loadingDataExpectation.expectedFulfillmentCount = 2
        let handleErrorExpectation = expectation(description: "handleError is not expected to happen")
        handleErrorExpectation.isInverted = true
        
        await sut.bindToViewController().sink { output in
            
            // then
            switch output {
            case .getMovieListDidSucceed(let movies, let currentPage, let totalPages):
                XCTAssertEqual(movies, MovieListResponse.sample().results)
                XCTAssertEqual(currentPage, MovieListResponse.sample().page)
                XCTAssertEqual(totalPages, MovieListResponse.sample().totalPages)
                getMovieListDidSucceedExpectation.fulfill()
            case .loadingData(let isLoading):
                print("isLoading get called, result: \(isLoading) count = \(loadingDataCount)")
                if loadingDataCount == 0 {
                    XCTAssertEqual(isLoading, true)
                    loadingDataCount += 1
                    loadingDataExpectation.fulfill()
                } else if loadingDataCount == 1 {
                    XCTAssertEqual(isLoading, false)
                    loadingDataExpectation.fulfill()
                }
            case .handleError:
                handleErrorExpectation.fulfill()
            }
            
        }.store(in: &subscriptions)
        
        // when
        await sut.handleGetMovieResponse(page: 1)
        await fulfillment(of: [getMovieListDidSucceedExpectation,
                               loadingDataExpectation,
                               handleErrorExpectation], timeout: 2)
    }
    
    func test_handleGetMovieResponse_failure() async {
        // given
        networkService.mockMovieListResult = .failure(MTError.badConnection)
        var loadingDataCount = 0
        
        let getMovieListDidSucceedExpectation = expectation(description: "getMovieListDidSucceed not expected to happen")
        getMovieListDidSucceedExpectation.isInverted = true
        
        let loadingDataExpectation = expectation(description: "loadingData happens 2 times")
        loadingDataExpectation.expectedFulfillmentCount = 2
        let handleErrorExpectation = expectation(description: "handleError")
        
        await sut.bindToViewController().sink { output in
            
            // then
            switch output {
            case .getMovieListDidSucceed:
                getMovieListDidSucceedExpectation.fulfill()
            case .loadingData(let isLoading):
                if loadingDataCount == 0 {
                    XCTAssertEqual(isLoading, true)
                    loadingDataCount += 1
                    loadingDataExpectation.fulfill()
                } else if loadingDataCount == 1 {
                    XCTAssertEqual(isLoading, false)
                    loadingDataExpectation.fulfill()
                }
            case .handleError(let error):
                XCTAssertEqual(error.localizedDescription, MTError.badConnection.localizedDescription)
                handleErrorExpectation.fulfill()
            }
        }
        .store(in: &subscriptions)
        
        // when
        await sut.handleGetMovieResponse(page: 1)
        await fulfillment(of: [getMovieListDidSucceedExpectation,
                               loadingDataExpectation,
                               handleErrorExpectation], timeout: 2)
    }
    
}
