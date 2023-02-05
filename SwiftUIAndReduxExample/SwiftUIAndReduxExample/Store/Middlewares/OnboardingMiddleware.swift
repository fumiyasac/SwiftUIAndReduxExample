//
//  OnboardingMiddleware.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/05.
//

import Foundation

// MARK: - Function (Production)

// オンボーディングの表示フラグ値に応じたActionを発行する
// ※テストコードの場合は検証用のhomeMiddlewareのものに差し替える想定
func onboardingMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case _ as RequestOnboardingAction:
            // 👉 RequestOnboardingActionを受け取ったらその後にオンボーディングの表示フラグ値に応じた処理を実行する
            handleOnboardingStatus(dispatch: dispatch)
            default:
                break
        }
    }
}

func onboardingCloseMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case _ as CloseOnboardingAction:
            // 👉 CloseOnboardingActionを受け取ったらその後にオンボーディングの表示フラグ値を更新する
            changeOnboardingStatus()
            default:
                break
        }
    }
}

// MARK: - Private Function (Production)

// 👉 オンボーディングの表示フラグ値を取得し、条件に合致すれば該当するActionを発行するためのメソッド
// ※テストコードの場合は想定するStubデータを返すものに差し替える想定
private func handleOnboardingStatus(dispatch: @escaping Dispatcher) {
    let shouldShowOnboarding = OnboardingRepositoryFactory.create().shouldShowOnboarding()
    if shouldShowOnboarding {
        dispatch(ShowOnboardingAction())
    }
}

// 👉 オンボーディングの表示フラグ値を変更するためのメソッド
// ※テストコードの場合は想定するStubデータを返すものに差し替える想定
private func changeOnboardingStatus() {
    let _ = OnboardingRepositoryFactory.create().changeOnboardingStatusFalse()
}

// MARK: - Function (Mock for Show/Hide Onboarding)

func onboardingMockShowMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case _ as RequestOnboardingAction:
            // 👉 RequestOnboardingActionを受け取ったらその後にオンボーディングの表示フラグ値に応じた処理を実行する
            mockShowOnboardingStatus(dispatch: dispatch)
            default:
                break
        }
    }
}

func onboardingMockCloseMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case _ as CloseOnboardingAction:
            // 👉 CloseOnboardingActionを受け取ったらその後にオンボーディングの表示フラグ値を更新する
            changeOnboardingMockStatus()
            default:
                break
        }
    }
}

func onboardingMockHideMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case _ as RequestOnboardingAction:
            // 👉 RequestOnboardingActionを受け取ったらその後にオンボーディングの表示フラグ値に応じた処理を実行する
            mockShowOnboardingStatus(dispatch: dispatch)
            default:
                break
        }
    }
}

// MARK: - Private Function (Mock for Show/Hide Onboarding)

private func mockShowOnboardingStatus(dispatch: @escaping Dispatcher) {
    // この部分をMockに置き換えている（※実際はUserDefaultからの取得処理は実施しない）
    let shouldShowOnboarding = MockShowOnboardingRepositoryFactory.create().shouldShowOnboarding()
    if shouldShowOnboarding {
        dispatch(ShowOnboardingAction())
    }
}

private func mockHideOnboardingStatus(dispatch: @escaping Dispatcher) {
    // この部分をMockに置き換えている（※実際はUserDefaultからの取得処理は実施しない）
    let _ = MockHideOnboardingRepositoryFactory.create().shouldShowOnboarding()
}

private func changeOnboardingMockStatus() {
    // この部分をMockに置き換えている（※実際はUserDefaultへの登録は実施しない）
    let _ = MockShowOnboardingRepositoryFactory.create().changeOnboardingStatusFalse()
}
