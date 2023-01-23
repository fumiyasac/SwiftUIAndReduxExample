//
//  FavoriteMiddleware.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/23.
//

import Foundation

// APIリクエスト結果に応じたActionを発行する
// ※テストコードの場合は検証用のfavoriteMiddlewareのものに差し替える想定
func favoriteMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case let action as RequestFavoriteAction:
            // 👉 RequestFavoriteScenesActionを受け取ったらその後にAPIリクエスト処理を実行する
            requestFavoriteScenes(action: action, dispatch: dispatch)
            default:
                break
        }
    }
}

// 👉 APIリクエスト処理を実行するためのメソッド
// ※テストコードの場合は想定するStubデータを返すものに差し替える想定
private func requestFavoriteScenes(action: RequestFavoriteAction, dispatch: @escaping Dispatcher) {
    Task { @MainActor in
        do {
            let favoriteResponse = try await FavioriteRepositoryFactory.create().getFavioriteResponse()
            if let favoriteSceneResponse = favoriteResponse as? FavoriteSceneResponse {
                // お望みのレスポンスが取得できた場合は成功時のActionを発行する
                dispatch(SuccessFavoriteAction(favoriteSceneEntities: favoriteSceneResponse.result))
            } else {
                // お望みのレスポンスが取得できなかった場合はErrorをthrowして失敗時のActionを発行する
                throw APIError.error(message: "No FavoriteSceneResponse exists.")
            }
            dump(favoriteResponse)
        } catch APIError.error(let message) {
            // 通信エラーないしはお望みのレスポンスが取得できなかった場合は成功時のActionを発行する
            dispatch(FailureFavoriteAction())
            print(message)
        }
    }
}
