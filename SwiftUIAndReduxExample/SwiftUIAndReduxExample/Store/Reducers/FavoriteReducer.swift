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
    case _ as RequestFavoriteScenesAction:
        state.isLoading = true
        state.isError = false
    case let action as SuccessFavoriteScenesAction:
        state.favoriteScenes = action.favoriteSceneEntities
        state.isLoading = false
        state.isError = false
    case _ as FailureFavoriteScenesAction:
        state.isLoading = false
        state.isError = true
    default:
        break
    }
    return state
}
