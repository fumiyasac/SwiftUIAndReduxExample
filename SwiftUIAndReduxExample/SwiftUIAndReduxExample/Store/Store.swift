//
//  Store.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import Foundation

// MARK: - Typealias

typealias Dispatcher = (Action) -> Void
typealias Reducer<State: ReduxState> = (_ state: State, _ action: Action) -> State
typealias Middleware<StoreState: ReduxState> = (StoreState, Action, @escaping Dispatcher) -> Void

// MARK: - Protocol

protocol ReduxState {}

protocol Action {}

// MARK: - Store

final class Store<StoreState: ReduxState>: ObservableObject {

    // MARK: - Property

    @Published var state: StoreState
    var reducer: Reducer<StoreState>
    var middlewares: [Middleware<StoreState>]

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
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.state = weakSelf.reducer(
                weakSelf.state,
                action
            )
        }

        // MEMO: 利用するMiddlewareを適用
        middlewares.forEach { middleware in
            middleware(state, action, dispatch)
        }
    }
}
