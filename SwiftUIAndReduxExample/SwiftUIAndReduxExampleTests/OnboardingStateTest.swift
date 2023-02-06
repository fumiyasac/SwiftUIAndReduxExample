//
//  OnboardingStateTest.swift
//  SwiftUIAndReduxExampleTests
//
//  Created by 酒井文也 on 2023/02/06.
//

@testable import SwiftUIAndReduxExample
import Nimble
import Quick
import XCTest

final class OnboardingStateTest: XCTestCase {

    // MARK: - Function (test_showOnboardingIsTrue)

    func test_showOnboardingIsTrue() throws {
        // MEMO: Mock用のMiddlewareを適用したStoreを用意する（テスト対象のMiddlewareだけで差し支えはない）
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                onboardingMockShowMiddleware(),
                onboardingMockCloseMiddleware()
            ]
        )
        let expectationshowOnboardingTrue = self.expectation(description: "Expect showOnboarding is true.")
        let subscriber = store.$state.sink(receiveValue: { state in
            if state.onboardingState.showOnboarding == true {
                expectationshowOnboardingTrue.fulfill()
            }
        })
        store.dispatch(action: RequestOnboardingAction())
        waitForExpectations(timeout: 1.0, handler: { _ in
            let onboardingState = store.state.onboardingState
            XCTAssertEqual(true, onboardingState.showOnboarding)
        })
    }
}
