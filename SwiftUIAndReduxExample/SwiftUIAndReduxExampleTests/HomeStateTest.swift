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

    // 👉 取得したレスポンスがHomeState内のPropertyに反映されることを確認する
    func test_SuccessHomeResponse() throws {
        // MEMO: Mock用のMiddlewareを適用したStoreを用意する
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                homeMockSuccessMiddleware()
            ]
        )
    }
}
