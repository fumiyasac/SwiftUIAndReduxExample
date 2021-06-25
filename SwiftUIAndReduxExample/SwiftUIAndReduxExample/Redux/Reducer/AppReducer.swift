//
//  AppReducer.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/06/24.
//

import Foundation

// MARK: - Typealias

typealias Reducer = (_ state: AppState, _ action: AppActions) -> AppState

// MARK: - Protocols

func reducer(_ state: AppState, _ action: AppActions) -> AppState {
    // TODO: AppActionsの値を元にステートの値変化を反映する
    return state
}
