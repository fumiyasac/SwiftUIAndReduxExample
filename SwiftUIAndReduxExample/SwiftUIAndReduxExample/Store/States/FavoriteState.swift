//
//  FavoriteState.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/23.
//

import Foundation

struct FavoriteState: ReduxState, Equatable {

    // MARK: - Property

    // MEMO: 読み込み中¥状態
    var isLoading: Bool = false
    // MEMO: エラー状態
    var isError: Bool = false

    // MEMO: Favorite画面で利用する情報として必要なViewObject情報
    var favoritePhotosCardViewObjects: [FavoritePhotosCardViewObject] = []

    // MARK: - Equatable

    static func == (lhs: FavoriteState, rhs: FavoriteState) -> Bool {
        return lhs.isLoading == rhs.isLoading
            && lhs.isError == rhs.isError
            && lhs.favoritePhotosCardViewObjects == rhs.favoritePhotosCardViewObjects
    }
}
