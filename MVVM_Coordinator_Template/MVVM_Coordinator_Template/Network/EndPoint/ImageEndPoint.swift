//
//  ImageEndPoint.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-06.
//

import Foundation

struct ImageEndPoint: ImageEndPointType {
    
    var baseURLString: String {
        return AppEnvironment.imageURLString + "t/p/"
    }
    var imageSize: ImageSize
    
    var path: String
    
    func createURL() -> URL? {
        
        var urlString = baseURLString
        
        switch imageSize {
        case .small:
            urlString.append("w154/")
        case .medium:
            urlString.append("w185/")
        case .big:
            urlString.append("w500/")
        case .original:
            urlString.append("original/")
        }
        
        urlString.append(path)
        
        return URL(string: urlString)
    }
}
