//
//  ParameterEncoder.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-05.
//

import Foundation

protocol ParameterEncoding {
    static func encodeQueryItems(with parameters: Parameters, for urlRequest: inout URLRequest) throws
    static func encodeBody(with parameters: Parameters, for urlRequest: inout URLRequest) throws
}

class ParameterEncoder: ParameterEncoding {
    
    static func encodeQueryItems(with parameters: Parameters, for urlRequest: inout URLRequest) throws {
        
        guard let url = urlRequest.url else { throw MTError.missingURL}
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
    }
    
    static func encodeBody(with parameters: Parameters, for urlRequest: inout URLRequest) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
        } catch {
            throw MTError.encodingFailed
        }
    }
}
