//
//  FavoriteScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI
import CollectionViewPagingLayout

struct FavoriteScreenView: View {

    
    // MARK: - body

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                FavoriteCommonSectionView()
                FavoriteSwipePagingView()
            }
            .navigationBarTitle(Text("Favorite"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Preview

struct FavoriteScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteScreenView()
    }
}
