//
//  MovieListCellViewModel.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-09.
//

import UIKit

class MovieListCellViewModel: ObservableObject {
    
    let networkService: Networkable?
    @Published var movie: Movie
    @Published var image: UIImage?
    
    
    init(networkService: Networkable?, movie: Movie) {
        self.networkService = networkService
        self.movie = movie
    }
    
    func getPosterImage() {
        Task {
            let image = await networkService?.image.getImage(with: movie.posterPath ?? "", imageSize: .medium)
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }
    }
}
