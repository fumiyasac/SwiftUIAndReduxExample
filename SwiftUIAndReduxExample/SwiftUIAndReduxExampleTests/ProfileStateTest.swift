//
//  ProfileStateTest.swift
//  SwiftUIAndReduxExampleTests
//
//  Created by 酒井文也 on 2023/02/07.
//

@testable import SwiftUIAndReduxExample

import XCTest
import Combine

final class ProfileStateTest: XCTestCase {

    // stateの格納先が @Published なので購読のキャンセルができる様にしておく
    private var cancellables: [AnyCancellable] = []

    // 👉 取得したレスポンスがFavoriteState内のPropertyに反映されることを確認する(FavoritePhotosCardViewObjectの確認)
    func test_SuccessProfileResponse_FavoritePhotosCardViewObjects() throws {
        // MEMO: Mock用のMiddlewareを適用したStoreを用意する
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                profileMockSuccessMiddleware()
            ]
        )
        // MEMO: Storeから取得できたデータを格納するための変数
        var targetProfilePersonalViewObject: ProfilePersonalViewObject?
        // MEMO: テスト前状態のState値を作る
        let beforeTestState = store.state
        // MEMO: Combineの処理を利用した形でActionが発行された場合での値変化を監視する
        let expectationProfileSuccess = self.expectation(description: "Expect to get ProfilePersonalViewObject.")
        let _ = store.$state.sink(receiveValue: { changedState in
            if beforeTestState.profileState.profilePersonalViewObject != changedState.profileState.profilePersonalViewObject {
                targetProfilePersonalViewObject = changedState.profileState.profilePersonalViewObject
                expectationProfileSuccess.fulfill()
            }
        }).store(in: &cancellables)
        store.dispatch(action: RequestProfileAction())
        waitForExpectations(timeout: 2.0, handler: { _ in
            // Example: 総数と最初の内容ぐらいは確認しておくと良さそうに思います。
            XCTAssertEqual(100, targetProfilePersonalViewObject?.id, "ユーザーIDが正しい値であること")
            XCTAssertEqual("謎多き料理人", targetProfilePersonalViewObject?.nickname, "ユーザーのニックネームが正しい値であること")
            XCTAssertEqual("2022.11.16", targetProfilePersonalViewObject?.createdAt, "登録日が正しい値であること")
            XCTAssertEqual("https://ones-mind-topics.s3.ap-northeast-1.amazonaws.com/profile_avatar_sample.jpg", targetProfilePersonalViewObject?.avatarUrl?.absoluteString, "アバターのURLが正しい値であること")
        })
    }
    
    // 👉 取得したレスポンスがHomeState内のPropertyに反映されることを確認する(Errorの確認)
    func test_FailureProfileResponse() throws {
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                profileMockFailureMiddleware()
            ]
        )
        var targetIsError: Bool?
        let beforeTestState = store.state
        let expectationProfileFailure = self.expectation(description: "Expect to get Error.")
        let _ = store.$state.sink(receiveValue: { changedState in
            if beforeTestState.profileState.isError != changedState.profileState.isError {
                targetIsError = changedState.profileState.isError
                expectationProfileFailure.fulfill()
            }
        }).store(in: &cancellables)
        store.dispatch(action: RequestProfileAction())
        waitForExpectations(timeout: 2.0, handler: { _ in
            XCTAssertEqual(true, targetIsError)
        })
    }
}
