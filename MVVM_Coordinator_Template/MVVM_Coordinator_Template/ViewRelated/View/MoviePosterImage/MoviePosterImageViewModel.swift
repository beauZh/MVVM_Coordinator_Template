//
//  MoviePosterImageViewModel.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-18.
//

import UIKit
import Combine

class MoviePosterImageViewModel: ObservableObject {
    
    let networkService: Networkable
    let imagePath: String
    let imageSize: ImageSize
    
    @Published var image: UIImage? = nil
    
    private var cancellable: AnyCancellable?
    
    init(networkService: Networkable, imagePath: String, imageSize: ImageSize) {
        self.networkService = networkService
        self.imagePath = imagePath
        self.imageSize = imageSize
        
        Task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        let image = await networkService.image.getImage(with: imagePath, imageSize: imageSize)
        
        DispatchQueue.main.async { [weak self] in
            self?.image = image
        }
    }
}
