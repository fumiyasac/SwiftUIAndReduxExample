//
//  FavoriteActions.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/23.
//

import Foundation

struct RequestFavoriteAction: Action {}

struct SuccessFavoriteAction: Action {
    let favoriteSceneEntities: [FavoriteSceneEntity]
}

struct FailureFavoriteAction: Action {}
