//
//  MovieListView.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-09.
//

import SwiftUI

struct MovieListCellView: View {
    
    @ObservedObject var vm: MovieListCellViewModel
    
    @State var isImageLoaded = false
    
    var body: some View {
        
        VStack(alignment: .center) {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .renderingMode(.original)
                    .posterStyle(loaded: true, size: .medium)
                    .onAppear{
                        isImageLoaded = true
                    }
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .posterStyle(loaded: false, size: .medium)
                    .onAppear {
                        isImageLoaded = false
                        vm.getPosterImage()
                    }
            }
        }
    }
}

#Preview {
    MovieListCellView(vm: MovieListCellViewModel(networkService: NetworkService(), movie: Movie.sample()))
}
