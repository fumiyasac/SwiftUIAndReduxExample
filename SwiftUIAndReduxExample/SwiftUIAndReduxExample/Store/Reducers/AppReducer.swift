//
//  Reducers.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/17.
//

import Foundation

// MARK: - Function

func appReducer(_ state: AppState, _ action: Action) -> AppState {
    var state = state
    // MEMO: HomeReducerの適用
    state.homeState = homeReducer(state.homeState, action)
    // MEMO: FavoriteReducerの適用
    state.favoriteState = favoriteReducer(state.favoriteState, action)
    // MEMO: ProfileReducerの適用
    state.profileState = profileReducer(state.profileState, action)
    return state
}
