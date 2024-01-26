//
//  MovieListEndPoint.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-04.
//

import Foundation

enum MovieListEndPoint {
    case nowPlaying(page: Int)
    case popular(page: Int)
    case upcoming(page: Int)
    case topRated(page: Int)
}

extension MovieListEndPoint: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: AppEnvironment.baseURLString + "3/movie") else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        case .popular:
            return "popular"
        case .upcoming:
            return "upcoming"
        case .topRated:
            return "top_rated"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .nowPlaying, .popular, .upcoming, .topRated:
            return ["accept": "application/json",
                    "Authorization": AppEnvironment.accessToken]
        }
    }
    
    var queryParameter: Parameters? {
        switch self {
        case .nowPlaying(let page):
            return ["page": page,
                    "language": "en-US"]
        case .popular(let page):
            return ["page": page,
                    "language": "en-US"]
        case .upcoming(let page):
            return ["page": page,
                    "language": "en-US"]
        case .topRated(let page):
            return ["page": page,
                    "language": "en-US"]
        }
    }
    
    var bodyParameter: Parameters? {
        return nil
    }
}
