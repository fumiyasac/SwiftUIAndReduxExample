//
//  FavoriteReducer.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/23.
//

import Foundation

func favoriteReducer(_ state: FavoriteState, _ action: Action) -> FavoriteState {
    var state = state
    switch action {
    case _ as RequestFavoriteAction:
        state.isLoading = true
        state.isError = false
    case let action as SuccessFavoriteAction:
        // MEMO: 画面要素表示用
        state.favoritePhotosCardViewObjects = action.favoriteSceneEntities.map {
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
        state.isLoading = false
        state.isError = false
    case _ as FailureFavoriteAction:
        state.isLoading = false
        state.isError = true
    default:
        break
    }
    return state
}
