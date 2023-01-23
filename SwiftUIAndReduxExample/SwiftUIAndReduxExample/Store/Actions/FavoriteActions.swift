//
//  FavoriteActions.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/23.
//

import Foundation

struct RequestFavoriteScenesAction: Action {}

struct SuccessFavoriteScenesAction: Action {
    let favoriteSceneEntities: [FavoriteSceneEntity]
}

struct FailureFavoriteScenesAction: Action {}
