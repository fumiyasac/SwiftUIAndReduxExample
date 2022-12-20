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
                FavoriteSwipePagingView(favoritePhotosCardViewObjects: getFavoritePhotosCardViewObjects())
            }
            .navigationBarTitle(Text("Favorite"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: FavoriteScreenView Extension

extension FavoriteScreenView {
    
    // MARK: - Private Function

    private func getFavoritePhotosCardViewObjects() -> [FavoritePhotosCardViewObject] {
        // MEMO: Preview表示用にレスポンスを想定したJsonを読み込んで画面に表示させる
        let favoriteSceneResponse = getFavoriteSceneResponse()
        let favoritePhotosCardViewObjects = favoriteSceneResponse.result
            .map {
                FavoritePhotosCardViewObject(
                    id: $0.id,
                    photoUrl: URL(string: $0.photoUrl) ?? nil,
                    author: $0.author,
                    title: $0.title,
                    category: $0.category,
                    shopName: $0.shopName,
                    comment: $0.comment,
                    publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
                )
            }
        return favoritePhotosCardViewObjects
    }

    private func getFavoriteSceneResponse() -> FavoriteSceneResponse {
        guard let path = Bundle.main.path(forResource: "favorite_scenes", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let favoriteSceneResponse = try? JSONDecoder().decode(FavoriteSceneResponse.self, from: data) else {
            fatalError()
        }
        return favoriteSceneResponse
    }
}

// MARK: - Preview

struct FavoriteScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteScreenView()
    }
}
