//
//  MovieCellView.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-18.
//

import SwiftUI

fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct MovieCellView: View {
    
    let networkService: Networkable
    let movie: Movie
    
    
    var body: some View {
        HStack(spacing: 8) {
            MoviePosterImage(viewModel: MoviePosterImageViewModel(networkService: networkService, imagePath: movie.posterPath ?? "", imageSize: .medium))
                .fixedSize()
//                .animation(.spring)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title ?? "")
                    .font(.title2)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                HStack {
                    PopularityBadge(score: Int((movie.voteAverage ?? 0) * 10))
                    Text(formatter.string(from: movie.releaseDate ?? Date()))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }
                Text(movie.overview ?? "")
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .truncationMode(.tail)
            }
        }
        .padding([.top, .bottom], 8)
    }
}

#Preview {
    MovieCellView(networkService: NetworkService(), movie: Movie.sample())
}
