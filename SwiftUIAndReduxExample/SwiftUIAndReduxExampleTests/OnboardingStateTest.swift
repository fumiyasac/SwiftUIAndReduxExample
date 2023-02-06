//
//  OnboardingStateTest.swift
//  SwiftUIAndReduxExampleTests
//
//  Created by 酒井文也 on 2023/02/06.
//

@testable import SwiftUIAndReduxExample

import XCTest
import Combine

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
        // MEMO: テストの書き方は下記リンクを参考にしました。
        // https://stackoverflow.com/questions/59690913/how-do-i-properly-test-a-var-that-changes-through-a-publisher-in-my-viewmodel-in
        let expectationshowOnboardingTrue = self.expectation(description: "Expect showOnboarding is true.")
        let _ = store.$state.sink(receiveValue: { state in
            if state.onboardingState.showOnboarding == true {
                // 👉 ②対象のStateに変化が起こった場合にfulfill()を実行する
                expectationshowOnboardingTrue.fulfill()
            }
        }).store(in: &cancellables)
        // 👉 ③該当StateのPropertyを変更するためのActionを発行する
        store.dispatch(action: RequestOnboardingAction())
        waitForExpectations(timeout: 1.0, handler: { _ in
            // 👉 ④fulfill()を実行後には対象のState内のPropetyが想定した値へ変更されていることを確認する
            let onboardingState = store.state.onboardingState
            XCTAssertEqual(true, onboardingState.showOnboarding)
        })
    }
}
