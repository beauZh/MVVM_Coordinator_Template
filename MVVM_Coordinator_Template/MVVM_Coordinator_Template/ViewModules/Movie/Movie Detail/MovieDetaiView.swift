//
//  MovieDetaiView.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-14.
//

import SwiftUI


class HostingVCRefer {
    weak var hostingController: UIViewController?    // << wraps reference
}


struct MovieDetaiView: View {
    
    @ObservedObject var viewModel: MovieDetailViewModel
    var hostingVCRefer: HostingVCRefer?
    
    
    var body: some View {
        VStack(alignment: .center) {
            Text(viewModel.movieDetail?.title ?? "")
            
            Text(viewModel.movieDetail?.overview ?? "")
            
            Button("Go to Order 2") {
                
                
            }
            .tint(Color.purple)
            .buttonStyle(.bordered)
            
            
            Button("Go to Order 3") {
                
            }
            .tint(Color.yellow)
            .buttonStyle(.borderedProminent)
        }

    }
}

#Preview {
    MovieDetaiView(viewModel: MovieDetailViewModel(networkService: NetworkService(), movieId: Movie.sample().id))
}
