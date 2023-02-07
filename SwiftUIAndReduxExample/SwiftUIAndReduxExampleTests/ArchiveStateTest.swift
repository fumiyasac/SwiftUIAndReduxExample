//
//  ArchiveStateTest.swift
//  SwiftUIAndReduxExampleTests
//
//  Created by 酒井文也 on 2023/02/07.
//

@testable import SwiftUIAndReduxExample

import XCTest
import Combine

final class ArchiveStateTest: XCTestCase {

    // stateの格納先が @Published なので購読のキャンセルができる様にしておく
    private var cancellables: [AnyCancellable] = []

    // MARK: - Function (test_SuccessArchiveResponse)

    // 👉 取得したレスポンスがArchiveState内のPropertyに反映されることを確認する(ArchiveCellViewObjectの確認)
    func test_SuccessArchiveResponse_WithNoConditions() throws {
        // MEMO: Mock用のMiddlewareを適用したStoreを用意する
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                archiveMockSuccessMiddleware(),
                addMockArchiveObjectMiddleware(),
                deleteMockArchiveObjectMiddleware()
            ]
        )
        // MEMO: Storeから取得できたデータを格納するための変数
        var targetArchiveCellViewObjects: [ArchiveCellViewObject] = []
        // MEMO: テスト前状態のState値を作る
        let beforeTestState = store.state
        // MEMO: Combineの処理を利用した形でActionが発行された場合での値変化を監視する
        let expectationArchiveSuccessWithNoConditions = self.expectation(description: "Expect to get ArchiveCellViewObjects (with no conditions).")
        let _ = store.$state.sink(receiveValue: { changedState in
            if beforeTestState.archiveState.archiveCellViewObjects != changedState.archiveState.archiveCellViewObjects {
                targetArchiveCellViewObjects = changedState.archiveState.archiveCellViewObjects
                expectationArchiveSuccessWithNoConditions.fulfill()
            }
        }).store(in: &cancellables)
        store.dispatch(action: RequestArchiveWithNoConditionsAction())
        waitForExpectations(timeout: 2.0, handler: { _ in
            // Example: 総数と最初の内容ぐらいは確認しておくと良さそうに思います。
            XCTAssertEqual(36, targetArchiveCellViewObjects.count, "表示コンテンツ一覧は合計36件取得できること")
            let firstViewObject = targetArchiveCellViewObjects.first
            XCTAssertEqual(1, firstViewObject?.id, "1番目のidが正しい値であること")
            XCTAssertEqual("エスニック料理", firstViewObject?.category, "1番目のcategoryが正しい値であること")
            XCTAssertEqual("ベトナム風生春巻き", firstViewObject?.dishName, "1番目のdishNameが正しい値であること")
            XCTAssertEqual("美味しいベトナム料理のお店", firstViewObject?.shopName, "1番目のshopNameが正しい値であること")
            XCTAssertEqual("エスニック料理の定番メニュー！ちょっと甘酸っぱいピリ辛のソースとの相性が抜群です。", firstViewObject?.introduction, "1番目のintroductionが正しい値であること")
        })
    }

    // MARK: - Function (test_FailureArchiveResponse)

    // 👉 取得したレスポンスがArchiveState内のPropertyに反映されることを確認する(Errorの確認)
    func test_FailureArchiveResponse() throws {
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                archiveMockFailureMiddleware(),
                addMockArchiveObjectMiddleware(),
                deleteMockArchiveObjectMiddleware()
            ]
        )
        var targetIsError: Bool?
        let beforeTestState = store.state
        let expectationArchiveFailure = self.expectation(description: "Expect to get Error.")
        let _ = store.$state.sink(receiveValue: { changedState in
            if beforeTestState.archiveState.isError != changedState.archiveState.isError {
                targetIsError = changedState.archiveState.isError
                expectationArchiveFailure.fulfill()
            }
        }).store(in: &cancellables)
        store.dispatch(action: RequestArchiveWithNoConditionsAction())
        waitForExpectations(timeout: 2.0, handler: { _ in
            XCTAssertEqual(true, targetIsError)
        })
    }
}
