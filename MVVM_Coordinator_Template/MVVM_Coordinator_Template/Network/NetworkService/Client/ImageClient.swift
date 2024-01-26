//
//  ImageClient.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-07.
//

import UIKit

protocol ImageClient {
    func getImage(with path: String, imageSize: ImageSize) async -> UIImage?
}

class APIImageClient: ImageClient {
    private unowned let networkService: Networkable
    
    init(networkService: Networkable) {
        self.networkService = networkService
    }
    
    func getImage(with path: String, imageSize: ImageSize) async -> UIImage? {
        return await networkService.requestImage(from: ImageEndPoint(imageSize: imageSize, path: path))
    }
}
