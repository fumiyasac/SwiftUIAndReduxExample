//
//  HomeStateTest.swift
//  SwiftUIAndReduxExampleTests
//
//  Created by 酒井文也 on 2023/02/07.
//

@testable import SwiftUIAndReduxExample

import XCTest
import Combine
import CombineExpectations
import Nimble
import Quick

// MEMO: CombineExpectationsを利用してUnitTestを作成する
// https://github.com/groue/CombineExpectations#usage

final class HomeStateTest: QuickSpec {

    // MARK: - Override

    override func spec() {
        // MEMO: Quick+NimbleをベースにしたUnitTestを実行する
        describe("#Home画面表示のテストケース") {
            // 👉 storeをインスタンス化する際に、想定するMiddlewareのMockを適用する
            let successStore = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: [
                    homeMockSuccessMiddleware()
                ]
            )
            let failureStore = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: [
                    homeMockFailureMiddleware()
                ]
            )
            // CombineExpectationを利用してAppStateの変化を記録するようにしたい
            // 👉 このサンプルではAppStateで`@Published`を利用しているので、AppStateを記録対象とする
            var homeStateSuccessRecorder: Recorder<AppState, Never>!
            var homeStateFailureRecorder: Recorder<AppState, Never>!
            context("表示するデータ取得処理が成功する場合") {
                beforeEach {
                    homeStateSuccessRecorder = successStore.$state.record()
                }
                afterEach {
                    homeStateSuccessRecorder = nil
                }
                successStore.dispatch(action: RequestHomeAction())
                // 対象のState値が変化することを確認する
                // ※ homeStateはImmutable / Recorderで対象秒間における値変化を全て保持している
                it("homeStateに想定している値が格納された状態であること") {
                    // timeout部分で5.00秒後の変化を見る（※async/await処理の場合は5.00秒ぐらいを見る）
                    let homeStateSuccessRecorderResult = try! self.wait(for: homeStateSuccessRecorder.availableElements, timeout: 5.00)
                    // 5.00秒間の変化を見て、最後の値が変化していることを確認する
                    let targetResult = homeStateSuccessRecorderResult.last!
                    // 👉 特徴的なテストケースをいくつか準備する（このテストコードで返却されるのは仮のデータではあるものの該当Stateにマッピングされる想定）
                    let homeState = targetResult.homeState
                    // (1) CampaignBannerCarouselViewObject
                    let campaignBannerCarouselViewObjects = homeState.campaignBannerCarouselViewObjects
                    let firstCampaignBannerCarouselViewObject = campaignBannerCarouselViewObjects.first
                    // 季節の特集コンテンツ一覧は合計6件取得できること
                    expect(campaignBannerCarouselViewObjects.count).to(equal(6))
                    // 1番目のidが正しい値であること
                    expect(firstCampaignBannerCarouselViewObject?.id).to(equal(1))
                    // 1番目のbannerContentsIdが正しい値であること
                    expect(firstCampaignBannerCarouselViewObject?.bannerContentsId).to(equal(1001))
                    // (2) RecentNewsCarouselViewObject
                    let recentNewsCarouselViewObjects = homeState.recentNewsCarouselViewObjects
                    let lastCampaignBannerCarouselViewObject = recentNewsCarouselViewObjects.last
                    // 最新のお知らせは合計12件取得できること
                    expect(recentNewsCarouselViewObjects.count).to(equal(12))
                    // 最後のidが正しい値であること
                    expect(lastCampaignBannerCarouselViewObject?.id).to(equal(12))
                    // 最後のtitleが正しい値であること
                    expect(lastCampaignBannerCarouselViewObject?.title).to(equal("美味しいみかんの年末年始の対応について"))
                }
            }
            context("#Home画面で表示するデータ取得処理が失敗した場合") {
                beforeEach {
                    homeStateFailureRecorder = failureStore.$state.record()
                }
                afterEach {
                    homeStateFailureRecorder = nil
                }
                failureStore.dispatch(action: RequestHomeAction())
                it("homeStateのisErrorがtrueとなること") {
                    let homeStateFailureRecorderResult = try! self.wait(for: homeStateFailureRecorder.availableElements, timeout: 5.00)
                    let targetResult = homeStateFailureRecorderResult.last!
                    let homeState = targetResult.homeState
                    let isError = homeState.isError
                    expect(isError).to(equal(true))
                }
            }
        }
    }
}
