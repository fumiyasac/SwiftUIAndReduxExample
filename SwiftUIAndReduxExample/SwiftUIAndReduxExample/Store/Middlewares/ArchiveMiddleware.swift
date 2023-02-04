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

// Archiveデータ登録処理を実行する
// ※テストコードの場合は検証用のarchiveMiddlewareのものに差し替える想定
func addArchiveObjectMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case let action as AddArchiveObjectAction:
            addArchiveObjectToRealm(archiveCellViewObject: action.archiveCellViewObject)
            default:
                break
        }
    }
}

// Archiveデータ削除処理を実行する
// ※テストコードの場合は検証用のarchiveMiddlewareのものに差し替える想定
func deleteArchiveObjectMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case let action as DeleteArchiveObjectAction:
            deleteArchiveObjectFromRealm(archiveCellViewObject: action.archiveCellViewObject)
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

// 👉 対象のViewObjectの内容をRealmへ登録するためのメソッド
private func addArchiveObjectToRealm(archiveCellViewObject: ArchiveCellViewObject) {
    StoredArchiveDataRepositoryFactory.create().createToRealm(archiveCellViewObject: archiveCellViewObject)
}

// 👉 対象のViewObjectの内容をRealmから削除するためのメソッド
private func deleteArchiveObjectFromRealm(archiveCellViewObject: ArchiveCellViewObject) {
    StoredArchiveDataRepositoryFactory.create().deleteFromRealm(archiveCellViewObject: archiveCellViewObject)
}

// MARK: - Function (Mock for Success)

// テストコードで利用するAPIリクエスト結果に応じたActionを発行する（Success時）
func archiveMockSuccessMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        // 👉 本来はAPIリクエスト処理やRealmからのデータ取得処理をMockに置き換えたもので代用する関数を実行する
        switch action {
            case let action as RequestArchiveWithInputTextAction:
            let selectedCategory = state.archiveState.selectedCategory
            mockSuccessRequestArchiveScenes(
                inputText: action.inputText,
                selectedCategory: selectedCategory,
                dispatch: dispatch
            )
            case let action as RequestArchiveWithSelectedCategoryAction:
            let inputText = state.archiveState.inputText
            mockSuccessRequestArchiveScenes(
                inputText: inputText,
                selectedCategory: action.selectedCategory,
                dispatch: dispatch
            )
            case _ as RequestArchiveWithNoConditionsAction:
            mockSuccessRequestArchiveScenes(
                inputText: "",
                selectedCategory: "",
                dispatch: dispatch
            )
            default:
                break
        }
    }
}

// MARK: - Function (Mock for Failure)

// テストコードで利用するAPIリクエスト結果に応じたActionを発行する（Failure時）
func archiveMockFailureMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            // 👉 処理失敗を想定したmock用関数を実行する
            case _ as RequestArchiveWithInputTextAction:
                mockFailureRequestArchiveScenes(dispatch: dispatch)
            case _ as RequestArchiveWithSelectedCategoryAction:
                mockFailureRequestArchiveScenes(dispatch: dispatch)
            case _ as RequestArchiveWithNoConditionsAction:
                mockFailureRequestArchiveScenes(dispatch: dispatch)
            default:
                break
        }
    }
}

// MARK: - Private Function (Dispatch Action Success/Failure)

// 👉 成功時のAPIリクエストを想定した処理を実行するためのメソッド
private func mockSuccessRequestArchiveScenes(inputText: String, selectedCategory: String, dispatch: @escaping Dispatcher) {
    Task { @MainActor in
        let _ = try await Task.sleep(for: .seconds(0.64))
        // 👉 実際はRealmへの処理ではあるが、MockはDictionaryを利用する処理としている
        let storedIds = MockStoredArchiveDataRepositoryFactory.create().getAllObjectsFromRealm()
            .map { $0.id }
        let archiveResponse = try await MockSuccessRequestArchiveRepositoryFactory.create().getArchiveResponse(keyword: inputText, category: selectedCategory)
        if let archiveSceneResponse = archiveResponse as? ArchiveSceneResponse {
            dispatch(
                SuccessArchiveAction(
                    archiveSceneEntities: archiveSceneResponse.result,
                    storedIds: storedIds
                )
            )
        } else {
            throw APIError.error(message: "No favoriteSceneResponse exists.")
        }
    }
}

// 👉 失敗時のAPIリクエストを想定した処理を実行するためのメソッド
private func mockFailureRequestArchiveScenes(dispatch: @escaping Dispatcher) {
    Task { @MainActor in
        let _ = try await Task.sleep(for: .seconds(0.64))
        dispatch(FailureArchiveAction())
    }
}

// MARK: - Function (Mock for Add/Delete Realm)

// Mock処理に差し替えたArchiveデータ登録処理を実行する
func addMockArchiveObjectMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case let action as AddArchiveObjectAction:
            addMockArchiveObjectToRealm(archiveCellViewObject: action.archiveCellViewObject)
            default:
                break
        }
    }
}

// Mock処理に差し替えたArchiveデータ削除処理を実行する
func deleteMockArchiveObjectMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case let action as DeleteArchiveObjectAction:
            deleteMockArchiveObjectFromRealm(archiveCellViewObject: action.archiveCellViewObject)
            default:
                break
        }
    }
}

// MARK: - Private Function (Mock for Add/Delete Realm)

private func addMockArchiveObjectToRealm(archiveCellViewObject: ArchiveCellViewObject) {
    MockStoredArchiveDataRepositoryFactory.create().createToRealm(archiveCellViewObject: archiveCellViewObject)
}

private func deleteMockArchiveObjectFromRealm(archiveCellViewObject: ArchiveCellViewObject) {
    MockStoredArchiveDataRepositoryFactory.create().deleteFromRealm(archiveCellViewObject: archiveCellViewObject)
}
