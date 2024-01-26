//
//  NetworkService.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-04.
//

import UIKit

protocol Networkable: AnyObject {
    var movie: MovieClient! { get }
    var image: ImageClient! { get }
    
    func request<T: Decodable>(endpoint: EndPointType) async throws -> T
    func requestImage(from imageEndpoint: ImageEndPointType) async -> UIImage?
}

class NetworkService: Networkable {
    
    private let cacheManager: CacheManager
    
    var movie: MovieClient!
    var image: ImageClient!
    
    init() {
        cacheManager = CacheManager.shared
        
        movie = ApiMovieClient(networkService: self)
        image = APIImageClient(networkService: self)
    }
    
    func request<T: Decodable>(endpoint: EndPointType) async throws -> T {
        do {
            let urlRequest = try createRequest(from: endpoint)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                throw MTError.badResponse(response.statusCode)
            }
            return try JSONDecoder.mtDecoder.decode(T.self, from: data)
        } catch {
            /// First try may return MTError.missingURL MTError.encodingFailed
            /// second try may return URLError
            /// response may throw badResponse error
            /// JSONDecoder may return dateNotParsableError
            throw MTError.convert(error: error)
        }
    }
    
    func requestImage(from imageEndpoint: ImageEndPointType) async -> UIImage? {
        if let image = cacheManager.getImage(for: imageEndpoint.path) {
            return image
        }
        
        do {
            guard let url = imageEndpoint.createURL() else {
                return nil
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               let image = UIImage(data: data) {
                cacheManager.setImage(for: imageEndpoint.path, with: image)
                return image
            }
            return nil
        } catch {
            return nil
        }
    }
    
    fileprivate func createRequest(from endPoint: EndPointType) throws -> URLRequest {
        
        var request = URLRequest(url: endPoint.baseURL.appendingPathComponent(endPoint.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = endPoint.httpMethod.rawValue
        request.allHTTPHeaderFields = endPoint.headers
        
        do {
            if let bodyParameter = endPoint.bodyParameter {
                try ParameterEncoder.encodeBody(with: bodyParameter, for: &request)
            }
            if let queryParameter = endPoint.queryParameter {
                try ParameterEncoder.encodeQueryItems(with: queryParameter , for: &request)
            }
        } catch {
            // MTError.missingURL MTError.encodingFailed
            throw error
        }
        
        return request
    }
}
