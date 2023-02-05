//
//  OnboardingState.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/05.
//

import Foundation

struct OnboardingState: ReduxState, Equatable {

    // MARK: - Property

    // MEMO: オンボーディング表示フラグ
    var showOnboarding: Bool = false

    // MARK: - Equatable

    static func == (lhs: OnboardingState, rhs: OnboardingState) -> Bool {
        return lhs.showOnboarding == rhs.showOnboarding
    }
}
