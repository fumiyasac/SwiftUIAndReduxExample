//
//  Store.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import Foundation

// MEMO: Store部分はasync/awaitで書くなら、MainActorで良いんじゃないかという仮説
// https://developer.apple.com/forums/thread/690957

// FYI: 他にも全体的にCombineを利用した書き方も可能 (※他にも事例は探してみると面白そう)
// https://wojciechkulik.pl/ios/redux-architecture-and-mind-blowing-features
// https://kazaimazai.com/redux-in-ios/
// https://www.raywenderlich.com/22096649-getting-a-redux-vibe-into-swiftui

// MARK: - Typealias

// 👉 Dispatcher・Reducer・Middlewareのtypealiasを定義する
// ※おそらくエッセンスとしてはReact等の感じに近くなるイメージとなる
typealias Dispatcher = (Action) -> Void
typealias Reducer<State: ReduxState> = (_ state: State, _ action: Action) -> State
typealias Middleware<StoreState: ReduxState> = (StoreState, Action, @escaping Dispatcher) -> Void

// MARK: - Protocol

protocol ReduxState {}

protocol Action {}

// MARK: - Store

final class Store<StoreState: ReduxState>: ObservableObject {

    // MARK: - Property

    @Published private(set) var state: StoreState
    private var reducer: Reducer<StoreState>
    private var middlewares: [Middleware<StoreState>]

    // MARK: - Initialzer

    init(
        reducer: @escaping Reducer<StoreState>,
        state: StoreState,
        middlewares: [Middleware<StoreState>] = []
    ) {
        self.reducer = reducer
        self.state = state
        self.middlewares = middlewares
    }

    // MARK: - Function

    func dispatch(action: Action) {

        // MEMO: Actionを発行するDispatcherの定義
        // 👉 新しいstateに差し替える処理については、メインスレッドで操作したいのでMainActor内で実行する
        Task { @MainActor in
            self.state = reducer(
                self.state,
                action
            )
        }

        // MEMO: 利用する全てのMiddlewareを適用
        middlewares.forEach { middleware in
            middleware(state, action, dispatch)
        }
    }
}
