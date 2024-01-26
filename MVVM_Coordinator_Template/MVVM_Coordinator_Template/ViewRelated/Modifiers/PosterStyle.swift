//
//  PosterStyle.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-18.
//

import SwiftUI

struct PosterStyle: ViewModifier {
    
    
    let loaded: Bool
    let size: ImageSize
    
    func body(content: Content) -> some View {
        return content
            .frame(width: size.width(), height: size.height())
            .cornerRadius(5)
            .opacity(loaded ? 1 : 0.1)
            .shadow(radius: 8)
    }
}

extension View {
    func posterStyle(loaded: Bool, size: ImageSize) -> some View {
        return ModifiedContent(content: self, modifier: PosterStyle(loaded: loaded, size: size))
    }
}
