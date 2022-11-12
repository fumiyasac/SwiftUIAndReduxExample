//
//  Reducers.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/17.
//

import Foundation

// MARK: - Function

func appReducer(_ state: AppState, _ action: Action) -> AppState {

    var state = state

    // MEMO: HomeReducerの適用
    state.homeState = homeReducer(state.homeState, action)

    return state
}
