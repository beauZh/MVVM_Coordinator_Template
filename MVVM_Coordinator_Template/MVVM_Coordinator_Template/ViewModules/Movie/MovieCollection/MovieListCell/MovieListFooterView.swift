//
//  MovieListFooterView.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-10.
//

import SwiftUI

struct MovieListFooterView: View {
    
    @ObservedObject var viewModel: MovieListViewModel
    
    var body: some View {
        VStack(alignment: .trailing) {
            
            Text("Loading More page, current page: \(viewModel.currentPage), total pages: \(viewModel.totalPages ?? 0)")
                .font(.system(.footnote, weight: .semibold))
                .foregroundColor(Color(.darkGray))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
        }
    }
}
