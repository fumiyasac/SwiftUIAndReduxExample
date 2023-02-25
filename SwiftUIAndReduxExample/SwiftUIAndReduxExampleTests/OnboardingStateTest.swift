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


final class OnboardingStateTest: QuickSpec {

    // MARK: - Override

    override func spec() {

        // MEMO: Quick+NimbleをベースにしたUnitTestを実行する
        describe("#オンボーディング表示対象時のテストケース") {
            // 👉 storeをインスタンス化する際に、想定するMiddlewareのMockを適用する
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

        describe("#オンボーディング表示対象からオンボーディング画面を閉じる時のテストケース") {
            let store = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: [
                    onboardingMockShowMiddleware(),
                    onboardingMockCloseMiddleware()
                ]
            )
            var onboardingStateRecorder: Recorder<AppState, Never>!
            context("オンボーディング有無を判定するActionを発行した際に表示対象であったが、その後にオンボーディング画面を閉じた場合") {
                beforeEach {
                    onboardingStateRecorder = store.$state.record()
                }
                afterEach {
                    onboardingStateRecorder = nil
                }
                // 👉 オンボーディング可否を取得するActionを発行し、その後にオンボーディングを閉じるActionを発行する
                store.dispatch(action: RequestOnboardingAction())
                store.dispatch(action: CloseOnboardingAction())
                it("showOnboardingがfalseであること") {
                    let onboardingStateRecorderResult = try! self.wait(for: onboardingStateRecorder.availableElements, timeout: 0.16)
                    let targetResult = onboardingStateRecorderResult.last!
                    let showOnboarding = targetResult.onboardingState.showOnboarding
                    expect(showOnboarding).to(equal(false))
                }
            }
        }
    }
}

