//
//  MoviesTableFooterView.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-20.
//

import SwiftUI

struct MoviesTableFooterView: View {
    
    var currentPage: Int
    var totalPage: Int
    
    var body: some View {
        Text("current page: \(currentPage) , total pages: \(totalPage)")
            .font(.system(.footnote, weight: .semibold))
            .foregroundColor(Color(.darkGray))
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    MoviesTableFooterView(currentPage: 1, totalPage: 1)
}
