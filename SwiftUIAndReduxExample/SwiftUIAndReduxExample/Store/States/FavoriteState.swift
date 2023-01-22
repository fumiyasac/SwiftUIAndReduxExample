//
//  FavoriteState.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/23.
//

import Foundation

struct FavoriteState: ReduxState {
    // MEMO: 読み込み中¥状態
    var isLoading: Bool = false
    // MEMO: エラー状態
    var isError: Bool = false

    // MEMO: Favorite画面で利用する情報として必要なEntity情報
    var FavoriteScenes: [FavoriteSceneEntity] = []
}
