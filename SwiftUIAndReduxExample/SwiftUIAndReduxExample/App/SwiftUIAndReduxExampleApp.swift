//
//  SwiftUIAndReduxExampleApp.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/09/08.
//

import SwiftUI

@main
struct SwiftUIAndReduxExampleApp: App {

    // MEMO: AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // MARK: - Body

    var body: some Scene {
        // 👉 このアプリで利用するStoreを初期化する
        // ※ middlewaresの配列内にAPI通信/Realm/UserDefaultを操作するための関数を追加する
        // ※ TestCodeやPreview画面ではmiddlewaresの関数にはMockを適用する形にすればさらに良いかもしれない...
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                // MEMO: 正規の処理を実行するMiddlewareを登録する
                homeMiddleware(),
                favoriteMiddleware(),
                profileMiddleware(),
            ]
        )
        // 👉 ContentViewには.environmentObjectを経由してstoreを適用する
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
