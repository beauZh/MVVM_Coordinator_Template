//
//  MovieTableViewCell.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-18.
//

import UIKit
import SwiftUI

class MovieTableViewCell: UITableViewCell {
    static let reuseID = "MovieTableViewCell"

    func setupView(networkService: Networkable, movie: Movie) {
        contentConfiguration = UIHostingConfiguration {
            MovieCellView(networkService: networkService, movie: movie)
        }
    }
}
