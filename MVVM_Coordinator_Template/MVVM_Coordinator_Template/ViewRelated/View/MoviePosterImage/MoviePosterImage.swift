//
//  MoviePosterImage.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-18.
//

import SwiftUI

struct MoviePosterImage: View {
    
    @ObservedObject var viewModel: MoviePosterImageViewModel
    @State var isImageLoaded = false
    
    var body: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
                .renderingMode(.original)
                .posterStyle(loaded: true, size: viewModel.imageSize)
                .onAppear {
                    isImageLoaded = true
                }
                .animation(Animation.interpolatingSpring(stiffness: 60, damping: 10).delay(0.1), value: isImageLoaded)
                .transition(.opacity)
        } else {
            Rectangle()
                .foregroundColor(.gray)
                .posterStyle(loaded: false, size: viewModel.imageSize)
        }
    }
}


#Preview {
    MoviePosterImage(viewModel: MoviePosterImageViewModel(networkService: NetworkService(), imagePath: "/pHUCVSUCma3LHmb0WUBei1QGUtD.jpg", imageSize: .medium))
}
