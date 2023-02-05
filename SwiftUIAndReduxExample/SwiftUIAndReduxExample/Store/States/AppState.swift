//
//  AppState.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/17.
//

import Foundation

// MARK: - AppState

// 👉 アプリ全体のState定義（画面ないしは機能ごとのState定義を集約する部分）
struct AppState: ReduxState {
    // MEMO: Onboarding表示で利用するState
    var onboardingState: OnboardingState = OnboardingState()
    // MEMO: Home画面表示で利用するState
    var homeState: HomeState = HomeState()
    // MEMO: Archive画面表示で利用するState
    var archiveState: ArchiveState = ArchiveState()
    // MEMO: Favorite画面表示で利用するState
    var favoriteState: FavoriteState = FavoriteState()
    // MEMO: Profile画面表示で利用するState
    var profileState: ProfileState = ProfileState()
}
