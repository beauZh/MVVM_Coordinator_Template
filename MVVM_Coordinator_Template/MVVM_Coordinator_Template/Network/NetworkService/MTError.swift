//
//  MTError.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-04.
//

import Foundation

enum MTError: Error, CustomStringConvertible {
    case missingURL
    case encodingFailed
    case badConnection
    case urlSession(URLError?)
    case badResponse(Int)
    case noData
    case unableToDecode(DecodingError?)
    case dateNotParsableError
    case unknown(Error?)
    
    static func convert(error: Error) -> MTError {
        switch error {
        case is URLError:
            return .urlSession(error as? URLError)
        case is MTError:
            return error as! MTError
        default:
            return .unknown(error)
        }
    }
    
    var description: String {
        switch self {
        case .missingURL:
            return "URL is nil"
        case .encodingFailed:
            return "encoding failed"
        case .badConnection:
            return "get error in request"
        case .urlSession(let error):
            return "urlSession error: \(error.debugDescription)"
        case .badResponse(let statusCode):
            return "bad response with status code: \(statusCode)"
        case .noData:
            return "response returned with no data to decode"
        case .unableToDecode(let decodingError):
            return "decoding error: \(decodingError.debugDescription)"
        case .dateNotParsableError:
            return "unable to parse date"
        case .unknown(let error):
            return "unknown error \(error.debugDescription)"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .missingURL, .unknown:
            return "Something went wrong."
        case .encodingFailed:
            return "Something went wrong."
        case .badConnection:
            return "Please check your network connection."
        case .urlSession(let urlError):
            return urlError?.localizedDescription ?? "Something went wrong."
        case .noData:
            return "Something went wrong."
        case .badResponse(let statueCode):
            switch statueCode {
            case 401...500: return "You need to be authenticated first."
            case 501...599: return "Bad request."
            case 600: return "The url you requested is outdated."
            default: return "Something went wrong."
            }
        case .unableToDecode(let decodingError):
            return decodingError?.localizedDescription ?? "Something went wrong."
        case .dateNotParsableError:
            return "Something went wrong"
        }
    }
}
