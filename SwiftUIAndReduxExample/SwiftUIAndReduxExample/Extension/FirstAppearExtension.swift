//
//  FirstAppearExtension.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/19.
//

import Foundation
import SwiftUI

// MEMO: 最初の1度だけ処理を発火させるためのExtension
// 参考: https://www.swiftjectivec.com/swiftui-run-code-only-once-versus-onappear-or-task/

// MARK: - Extension

public extension View {

    // MARK: - Function

    func onFirstAppear(_ onceAction: @escaping () -> Void) -> some View {
        // 👉 FirstAppear Modifierを設定する
        modifier(FirstAppear(onceAction: onceAction))
    }
}

// MARK: - ViewModifier

private struct FirstAppear: ViewModifier {

    // MARK: - Property

    private let onceAction: () -> Void

    // 初回のみの実行かを判定するためのフラグ値
    @State private var hasAppeared = false

    // MARK: - Initializer

    init(onceAction: @escaping () -> Void) {
        self.onceAction = onceAction
        _hasAppeared = State(initialValue: false)
    }
    
    // MARK: - Body

    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else {
                return
            }
            // 👉 一度発火をしたらフラグ値を更新して以降は実行されない様にする
            hasAppeared = true
            // 👉 closureで引き渡された処理を一度だけ実行する
            onceAction()
        }
    }
}
