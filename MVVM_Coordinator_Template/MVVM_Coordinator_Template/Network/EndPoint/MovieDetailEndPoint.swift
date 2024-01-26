//
//  MovieDetailEndPoint.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-08.
//

import Foundation

enum MovieDetailEndPoint {
    case movieDetail(movieId: Int)
}

//"https://api.themoviedb.org/3/movie/movie_id?language=en-US"

extension MovieDetailEndPoint: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: AppEnvironment.baseURLString + "3/movie") else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .movieDetail(let movieId):
            return "\(movieId)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        ["accept": "application/json",
         "Authorization": AppEnvironment.accessToken]
    }
    
    var queryParameter: Parameters? {
        return ["language": "en-US"]
    }
    
    var bodyParameter: Parameters? {
        nil
    }
}
