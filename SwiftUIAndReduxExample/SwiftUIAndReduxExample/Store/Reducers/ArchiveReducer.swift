//
//  ArchiveReducer.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/02.
//

import Foundation

func archiveReducer(_ state: ArchiveState, _ action: Action) -> ArchiveState {
    var state = state
    switch action {
    case let action as RequestArchiveWithInputTextAction:
        state.isLoading = true
        state.isError = false
        state.inputText = action.inputText
    case let action as RequestArchiveWithSelectedCategoryAction:
        state.isLoading = true
        state.isError = false
        state.selectedCategory = action.selectedCategory
    case _ as RequestArchiveWithNoConditionsAction:
        state.isLoading = true
        state.isError = false
        state.inputText = ""
        state.selectedCategory = ""
    case let action as SuccessArchiveAction:
        // MEMO: 画面要素表示用
        let currentFavoriteState = action.isFavorite
        state.archiveCellViewObjects = action.archiveSceneEntities.map {
            ArchiveCellViewObject(
                id: $0.id,
                photoUrl: URL(string: $0.photoUrl) ?? nil,
                category: $0.category,
                dishName: $0.dishName,
                shopName: $0.shopName,
                introduction: $0.introduction,
                currentFavoriteState: currentFavoriteState
            )
        }
        state.isLoading = false
        state.isError = false
    case _ as FailureArchiveAction:
        state.isLoading = false
        state.isError = true
    default:
        break
    }
    return state
}
