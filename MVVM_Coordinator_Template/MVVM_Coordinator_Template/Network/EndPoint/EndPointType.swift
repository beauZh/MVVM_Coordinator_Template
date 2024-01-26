//
//  EndPointType.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-04.
//

import Foundation

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]
public enum HTTPMethod : String {
    case get = "GET", post = "POST", put = "PUT", patch = "PATCH" ,delete = "DELETE"
}

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    /// For post And delete:
    ///   ["accept": "application/json",
    ///    "content-type": "application/json",
    ///    "Authorization": "Bearer \(MTEnvironment.accessToken)"]
    /// For others:
    ///   ["accept": "application/json",
    ///    "Authorization": "Bearer \(MTEnvironment.accessToken)"]
    var headers: HTTPHeaders? { get }
    var queryParameter: Parameters? { get }
    var bodyParameter: Parameters? { get }
}

protocol ImageEndPointType {
    var baseURLString: String { get }
    var imageSize: ImageSize { get }
    var path: String { get }
    
    func createURL() -> URL?
}


// need to find a better place for this
enum ImageSize {
    case small, medium, big, original
    
    func width() -> CGFloat {
        switch self {
        case .small: return 53
        case .medium: return 100
        case .big: return 250
        case .original: return 333
        }
    }
    func height() -> CGFloat {
        switch self {
        case .small: return 80
        case .medium: return 150
        case .big: return 375
        case .original: return 500
        }
    }
}
