//
//  HomeStateTest.swift
//  SwiftUIAndReduxExampleTests
//
//  Created by 酒井文也 on 2023/02/07.
//

@testable import SwiftUIAndReduxExample

import XCTest
import Combine

// MEMO: テストの書き方は下記リンクを参考にしました。
// https://stackoverflow.com/questions/59690913/how-do-i-properly-test-a-var-that-changes-through-a-publisher-in-my-viewmodel-in

final class HomeStateTest: XCTestCase {

    // stateの格納先が @Published なので購読のキャンセルができる様にしておく
    private var cancellables: [AnyCancellable] = []

    // MARK: - Function (test_SuccessHomeResponse)

    // 👉 取得したレスポンスがHomeState内のPropertyに反映されることを確認する(CampaignBannerCarouselViewObjectの確認)
    func test_SuccessHomeResponse_CampaignBannerCarouselViewObjects() throws {
        // MEMO: Mock用のMiddlewareを適用したStoreを用意する
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                homeMockSuccessMiddleware()
            ]
        )
        // MEMO: Storeから取得できたデータを格納するための変数
        var targetCampaignBannerCarouselViewObjects: [CampaignBannerCarouselViewObject] = []
        // MEMO: テスト前状態のState値を作る
        let beforeTestState = store.state
        // MEMO: Combineの処理を利用した形でActionが発行された場合での値変化を監視する
        let expectationHomeSuccess = self.expectation(description: "Expect to get CampaignBannerCarouselViewObjects.")
        let _ = store.$state.sink(receiveValue: { changedState in
            if beforeTestState.homeState.campaignBannerCarouselViewObjects != changedState.homeState.campaignBannerCarouselViewObjects {
                targetCampaignBannerCarouselViewObjects = changedState.homeState.campaignBannerCarouselViewObjects
                expectationHomeSuccess.fulfill()
            }
        }).store(in: &cancellables)
        store.dispatch(action: RequestHomeAction())
        waitForExpectations(timeout: 2.0, handler: { _ in
            // Example: 総数と最初の内容ぐらいは確認しておくと良さそうに思います。
            XCTAssertEqual(6, targetCampaignBannerCarouselViewObjects.count, "季節の特集コンテンツ一覧は合計6件取得できること")
            let firstViewObject = targetCampaignBannerCarouselViewObjects.first
            XCTAssertEqual(1, firstViewObject?.id, "1番目のidが正しい値であること")
            XCTAssertEqual(1001, firstViewObject?.bannerContentsId, "1番目のbannerContentsIdが正しい値であること")
        })
    }

    // 👉 取得したレスポンスがHomeState内のPropertyに反映されることを確認する(RecentNewsCarouselViewObjectの確認)
    func test_SuccessHomeResponse_RecentNewsCarouselViewObjects() throws {
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                homeMockSuccessMiddleware()
            ]
        )
        var targetRecentNewsCarouselViewObjects: [RecentNewsCarouselViewObject] = []
        let beforeTestState = store.state
        let expectationHomeSuccess = self.expectation(description: "Expect to get RecentNewsCarouselViewObjects.")
        let _ = store.$state.sink(receiveValue: { changedState in
            if beforeTestState.homeState.recentNewsCarouselViewObjects != changedState.homeState.recentNewsCarouselViewObjects {
                targetRecentNewsCarouselViewObjects = changedState.homeState.recentNewsCarouselViewObjects
                expectationHomeSuccess.fulfill()
            }
        }).store(in: &cancellables)
        store.dispatch(action: RequestHomeAction())
        waitForExpectations(timeout: 2.0, handler: { _ in
            XCTAssertEqual(12, targetRecentNewsCarouselViewObjects.count, "最新のお知らせは合計12件取得できること")
            let lastViewObject = targetRecentNewsCarouselViewObjects.last
            XCTAssertEqual(12, lastViewObject?.id, "最後のidが正しい値であること")
            XCTAssertEqual("美味しいみかんの年末年始の対応について", lastViewObject?.title, "最後のtitleが正しい値であること")
        })
    }
    
    // 👉 取得したレスポンスがHomeState内のPropertyに反映されることを確認する(Errorの確認)
    func test_FailureHomeResponse() throws {
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                homeMockFailureMiddleware()
            ]
        )
        var targetIsError: Bool?
        let beforeTestState = store.state
        let expectationHomeFailure = self.expectation(description: "Expect to get Error.")
        let _ = store.$state.sink(receiveValue: { changedState in
            if beforeTestState.homeState.isError != changedState.homeState.isError {
                targetIsError = changedState.homeState.isError
                expectationHomeFailure.fulfill()
            }
        }).store(in: &cancellables)
        store.dispatch(action: RequestHomeAction())
        waitForExpectations(timeout: 2.0, handler: { _ in
            XCTAssertEqual(true, targetIsError)
        })
    }
}
