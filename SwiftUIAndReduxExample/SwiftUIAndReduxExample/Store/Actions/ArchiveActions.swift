//
//  ArchiveActions.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/02.
//

import Foundation

struct RequestArchiveWithInputTextAction: Action {
    let inputText: String
}

struct RequestArchiveWithSelectedCategoryAction: Action {
    let selectedCategory: String
}

struct RequestArchiveWithNoConditionsAction: Action {}

struct SuccessArchiveAction: Action {
    let archiveSceneEntities: [ArchiveSceneEntity]
    let isFavorite: Bool
}

struct FailureArchiveAction: Action {}

// MEMO: 下記2つのActionはStateの変化をさせない（Realmへの追加or削除を実行するだけ）のAction

struct AddFavoriteAboutAcrchiveAction: Action {
    let archiveCellViewObject: ArchiveCellViewObject
}

struct RemoveFromFavoriteAboutAcrchiveAction: Action {
    let archiveCellViewObject: ArchiveCellViewObject
}
