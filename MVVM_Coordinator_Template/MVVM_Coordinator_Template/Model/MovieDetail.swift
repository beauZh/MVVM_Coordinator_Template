//
//  MovieDetail.swift
//  MVVM_Coordinator_Template
//
//  Created by Bo Zhang on 2024-01-25.
//

import Foundation

struct MovieDetail: Codable {
    let adult: Bool
    let genres: [MovieDetailGenre]
    let id: Int
    let imdbId: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: Date
    let status: String
    let title: String
    let voteAverage: Double
    let voteCount: Int
    
    static func sample() -> MovieDetail {
        return MovieDetail(adult: false,
                           genres: [MovieDetailGenre(id: 1, name: "genre")],
                           id: 1,
                           imdbId: "12345",
                           originalLanguage: "Eng",
                           originalTitle: "originalTitle",
                           overview: "This is a test overview",
                           popularity: 1.23,
                           posterPath: "/12345.jpg",
                           releaseDate: Date(),
                           status: "status",
                           title: "title",
                           voteAverage: 7.54,
                           voteCount: 12345)
    }
    
}

struct MovieDetailGenre: Codable {
    let id: Int
    let name: String
}
