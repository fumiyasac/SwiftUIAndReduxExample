//
//  FavoriteContentsView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/29.
//

import SwiftUI

struct FavoriteContentsView: View {

    // MARK: - Property

    private let favoritePhotosCardViewObjects: [FavoritePhotosCardViewObject]
    
    // MARK: - Initializer

    init(favoritePhotosCardViewObjects: [FavoritePhotosCardViewObject]) {
        self.favoritePhotosCardViewObjects = favoritePhotosCardViewObjects
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            FavoriteCommonSectionView()
            FavoriteSwipePagingView(favoritePhotosCardViewObjects: favoritePhotosCardViewObjects)
        }
    }
}
