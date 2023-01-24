//
//  ProfileReducer.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/24.
//

import Foundation

func profileReducer(_ state: ProfileState, _ action: Action) -> ProfileState {
    var state = state
    switch action {
    case _ as RequestProfileAction:
        state.isLoading = true
        state.isError = false
    case let action as SuccessProfileAction:
        // MEMO: 画面要素表示用
        state.profilePersonal = action.profilePersonalEntity
        state.profileAnnoucements = action.profileAnnoucementEntities
        state.profileComments = action.profileCommentEntities
        state.profileRecentFavorites = action.profileRecentFavoriteEntities
        // MEMO: 画面表示ハンドリング用
        state.isLoading = false
        state.isError = false
    case _ as FailureProfileAction:
        state.isLoading = false
        state.isError = true
    default:
        break
    }
    return state
}
