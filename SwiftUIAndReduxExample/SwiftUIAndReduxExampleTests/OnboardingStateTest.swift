//
//  OnboardingStateTest.swift
//  SwiftUIAndReduxExampleTests
//
//  Created by 酒井文也 on 2023/02/06.
//

@testable import SwiftUIAndReduxExample

import XCTest
import Combine
import CombineExpectations
import Nimble
import Quick

// MEMO: テストの書き方は下記リンクを参考にしました。
// https://stackoverflow.com/questions/59690913/how-do-i-properly-test-a-var-that-changes-through-a-publisher-in-my-viewmodel-in

// MEMO: CombineExpectationsを利用してUnitTestを作成する
// https://github.com/groue/CombineExpectations#usage


final class OnboardingStateChangeTest: QuickSpec {

    // MARK: - Override

    override func spec() {

        // MEMO: Quick+NimbleをベースにしたUnitTestを実行する
        describe("#オンボーディング表示対象時のテストケース") {
            // 👉 storeをインスタンス化す際に、想定するMiddlewareのMockを適用する
            let store = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: [
                    onboardingMockShowMiddleware(),
                    onboardingMockCloseMiddleware()
                ]
            )
            // CombineExpectationを利用してAppStateの変化を記録するようにしたい
            // 👉 このサンプルではAppStateで`@Published`を利用しているので、AppStateを記録対象とする
            var onboardingStateRecorder: Recorder<AppState, Never>!
            context("オンボーディング有無を判定するActionを発行した際に表示対象であった場合") {
                // 👉 UnitTest実行前後で実行する処理
                beforeEach {
                    onboardingStateRecorder = store.$state.record()
                }
                afterEach {
                    onboardingStateRecorder = nil
                }
                // 👉 オンボーディング可否を取得するActionを発行する
                // この後にOnboardingStateの変化を見る
                store.dispatch(action: RequestOnboardingAction())
                // 対象のState値が変化することを確認する
                // ※ onboardingStateはImmutable / Recorderで対象秒間における値変化を全て保持している
                it("showOnboardingがtrueであること") {
                    // timeout部分で0.16秒後の変化を見る（※async/await処理の場合は1.00秒ぐらいを見る）
                    let onboardingStateRecorderResult = try! self.wait(for: onboardingStateRecorder.availableElements, timeout: 0.16)
                    // 0.16秒間の変化を見て、最後の値が変化していることを確認する
                    let targetResult = onboardingStateRecorderResult.last!
                    let showOnboarding = targetResult.onboardingState.showOnboarding
                    expect(showOnboarding).to(equal(true))
                }
            }
        }
        
    }
}

final class OnboardingStateTest: XCTestCase {

    // stateの格納先が @Published なので購読のキャンセルができる様にしておく
    private var cancellables: [AnyCancellable] = []

    // MARK: - Function (test_showOnboardingIsTrue)

    func test_showOnboardingIsTrue() throws {
        // MEMO: Mock用のMiddlewareを適用したStoreを用意する
        // 👉 ①テスト対象のMiddlewareだけの状態でOKです
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                onboardingMockShowMiddleware(),
                onboardingMockCloseMiddleware()
            ]
        )
        // MEMO: Storeから取得できたデータを格納するための変数
        var targetTestShowOnboarding: Bool?
        // MEMO: テスト前状態のState値を作る
        let beforeTestState = store.state
        // MEMO: Combineの処理を利用した形でActionが発行された場合での値変化を監視する
        let expectationshowOnboardingTrue = self.expectation(description: "Expect showOnboarding is true.")
        let _ = store.$state.sink(receiveValue: { changedState in
            // 👉 ②対象のState内Propertyに変化が起こった場合にfulfill()を実行する
            if beforeTestState.onboardingState.showOnboarding != changedState.onboardingState.showOnboarding {
                targetTestShowOnboarding = changedState.onboardingState.showOnboarding
                expectationshowOnboardingTrue.fulfill()
            }
        }).store(in: &cancellables)
        // 👉 ③該当StateのPropertyを変更するためのActionを発行する
        store.dispatch(action: RequestOnboardingAction())
        waitForExpectations(timeout: 1.0, handler: { _ in
            // 👉 ④fulfill()を実行後には対象のState内のPropetyが想定した値へ変更されていることを確認する
            XCTAssertEqual(true, targetTestShowOnboarding)
        })
    }
}
