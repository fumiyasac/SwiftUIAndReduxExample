//
//  FavoriteStateTest.swift
//  SwiftUIAndReduxExampleTests
//
//  Created by 酒井文也 on 2023/02/07.
//

@testable import SwiftUIAndReduxExample

import XCTest
import Combine

final class FavoriteStateTest: XCTestCase {

    // stateの格納先が @Published なので購読のキャンセルができる様にしておく
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Function (test_SuccessFavoriteResponse)

    // 👉 取得したレスポンスがFavoriteState内のPropertyに反映されることを確認する(FavoritePhotosCardViewObjectの確認)
    func test_SuccessFavoriteResponse_FavoritePhotosCardViewObjects() throws {
        // MEMO: Mock用のMiddlewareを適用したStoreを用意する
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                favoriteMockSuccessMiddleware()
            ]
        )
        // MEMO: Storeから取得できたデータを格納するための変数
        var targetFavoritePhotosCardViewObjects: [FavoritePhotosCardViewObject] = []
        // MEMO: テスト前状態のState値を作る
        let beforeTestState = store.state
        // MEMO: Combineの処理を利用した形でActionが発行された場合での値変化を監視する
        let expectationFavoriteSuccess = self.expectation(description: "Expect to get FavoritePhotosCardViewObject.")
        let _ = store.$state.sink(receiveValue: { changedState in
            if beforeTestState.favoriteState.favoritePhotosCardViewObjects != changedState.favoriteState.favoritePhotosCardViewObjects {
                targetFavoritePhotosCardViewObjects = changedState.favoriteState.favoritePhotosCardViewObjects
                expectationFavoriteSuccess.fulfill()
            }
        }).store(in: &cancellables)
        store.dispatch(action: RequestFavoriteAction())
        waitForExpectations(timeout: 2.0, handler: { _ in
            // Example: 総数と最初の内容ぐらいは確認しておくと良さそうに思います。
            XCTAssertEqual(12, targetFavoritePhotosCardViewObjects.count, "編集部が選ぶお気に入りのグルメは合計12件取得できること")
            let firstViewObject = targetFavoritePhotosCardViewObjects.first
            XCTAssertEqual(1, firstViewObject?.id, "1番目のidが正しい値であること")
            XCTAssertEqual("気になる一皿シリーズNo.1", firstViewObject?.title, "1番目のtitleが正しい値であること")
        })
    }

    // MARK: - Function (test_FailureFavoriteResponse)

    // 👉 取得したレスポンスがHomeState内のPropertyに反映されることを確認する(Errorの確認)
    func test_FailureFavoriteResponse() throws {
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                favoriteMockFailureMiddleware()
            ]
        )
        var targetIsError: Bool?
        let beforeTestState = store.state
        let expectationFavoriteFailure = self.expectation(description: "Expect to get Error.")
        let _ = store.$state.sink(receiveValue: { changedState in
            if beforeTestState.favoriteState.isError != changedState.favoriteState.isError {
                targetIsError = changedState.favoriteState.isError
                expectationFavoriteFailure.fulfill()
            }
        }).store(in: &cancellables)
        store.dispatch(action: RequestFavoriteAction())
        waitForExpectations(timeout: 2.0, handler: { _ in
            XCTAssertEqual(true, targetIsError)
        })
    }
}
