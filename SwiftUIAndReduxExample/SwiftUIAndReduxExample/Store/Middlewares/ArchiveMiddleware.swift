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
        // TODO: Realm処理とAPIリクエスト処理を組み合わせてレスポンスを取得する
    }
}
