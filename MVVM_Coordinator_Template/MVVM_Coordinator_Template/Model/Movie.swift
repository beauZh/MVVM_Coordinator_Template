//
//  Movie.swift
//  MVVM_Coordinator_Template
//
//  Created by Bo Zhang on 2024-01-25.
//

import Foundation

struct Movie: Codable, Hashable {
    let id: Int
    var title: String?
    let releaseDate: Date?
    let overview: String?
    let posterPath: String?
    let voteAverage: Double?
    
    static func sample() -> Movie {
        return Movie(id: 569930, title: "Napoleon", releaseDate: nil, overview: "An epic that details the checkered rise and fall of French Emperor Napoleon Bonaparte and his relentless journey to power through the prism of his addictive, volatile relationship with his wife, Josephine.", posterPath: "/pHUCVSUCma3LHmb0WUBei1QGUtD.jpg", voteAverage: 7.29)
    }
}

struct MovieListResponse: Codable, Hashable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    static func sample() -> MovieListResponse {
        return MovieListResponse(page: 1, results: [Movie.sample()], totalPages: 10, totalResults: 20)
    }
}
