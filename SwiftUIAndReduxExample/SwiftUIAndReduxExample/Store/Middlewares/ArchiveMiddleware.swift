//
//  ArchiveMiddleware.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/03.
//

import Foundation

// MARK: - Function (Production)

// APIリクエスト結果に応じたActionを発行する
// ※テストコードの場合は検証用のarchiveMiddlewareのものに差し替える想定
func archiveMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            // 👉 選択カテゴリー・入力テキスト値の変更を受け取ったらその後にAPIリクエスト処理を実行する
            // 複合条件の処理をするために現在Stateに格納されている値も利用する
            case let action as RequestArchiveWithInputTextAction:
            let selectedCategory = state.archiveState.selectedCategory
            requestArchiveScenes(
                inputText: action.inputText,
                selectedCategory: selectedCategory,
                dispatch: dispatch
            )
            case let action as RequestArchiveWithSelectedCategoryAction:
            let inputText = state.archiveState.inputText
            requestArchiveScenes(
                inputText: inputText,
                selectedCategory: action.selectedCategory,
                dispatch: dispatch
            )
            case _ as RequestArchiveWithNoConditionsAction:
            requestArchiveScenes(
                inputText: "",
                selectedCategory: "",
                dispatch: dispatch
            )
            default:
                break
        }
    }
}

// MARK: - Private Function (Production)

// 👉 APIリクエスト処理を実行するためのメソッド
// ※テストコードの場合は想定するStubデータを返すものに差し替える想定
private func requestArchiveScenes(inputText: String, selectedCategory: String, dispatch: @escaping Dispatcher) {
    Task { @MainActor in
        do {
            // 👉 Realm内に登録されているデータのIDだけを詰め込んだ配列に変換する
            let storedIds = StoredArchiveDataRepositoryFactory.create().getAllObjectsFromRealm()
                .map { $0.id }
            // 👉 Realm内に登録されているデータのIDだけを詰め込んだ配列に変換する
            // 🌟 最終的にViewObjectに変換をするのはArchiveReducerで実行する
            let archiveResponse = try await RequestArchiveRepositoryFactory.create().getArchiveResponse(keyword: inputText, category: selectedCategory)
            if let archiveSceneResponse = archiveResponse as? ArchiveSceneResponse {
                // お望みのレスポンスが取得できた場合は成功時のActionを発行する
                dispatch(
                    SuccessArchiveAction(
                        archiveSceneEntities: archiveSceneResponse.result,
                        storedIds: storedIds
                    )
                )
            } else {
                // お望みのレスポンスが取得できなかった場合はErrorをthrowして失敗時のActionを発行する
                throw APIError.error(message: "No FavoriteSceneResponse exists.")
            }
            dump(archiveResponse)
        } catch APIError.error(let message) {
            // 通信エラーないしはお望みのレスポンスが取得できなかった場合は成功時のActionを発行する
            dispatch(FailureArchiveAction())
            print(message)
        }
    }
}
