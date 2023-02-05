//
//  Reducers.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/17.
//

import Foundation

// MARK: - Function

// 👉 AppReducerはそれぞれの画面で利用するReducerを集約している部分

func appReducer(_ state: AppState, _ action: Action) -> AppState {
    var state = state
    // MEMO: OnboardingReducerの適用
    state.onboardingState = onboardingReducer(state.onboardingState, action)
    // MEMO: HomeReducerの適用
    state.homeState = homeReducer(state.homeState, action)
    // MEMO: ArchiveReducerの適用
    state.archiveState = archiveReducer(state.archiveState, action)
    // MEMO: FavoriteReducerの適用
    state.favoriteState = favoriteReducer(state.favoriteState, action)
    // MEMO: ProfileReducerの適用
    state.profileState = profileReducer(state.profileState, action)
    return state
}
