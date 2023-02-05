//
//  OnboardingRepository.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/05.
//

import Foundation
import SwiftyUserDefaults

// MARK: - Protocol

protocol OnboardingRepository {
    func shouldShowOnboarding() -> Bool
    func changeOnboardingStatusFalse()
}

final class OnboardingRepositoryImpl: OnboardingRepository {

    // MARK: - Function

    func shouldShowOnboarding() -> Bool {
        let result = Defaults[\.onboardingStatus]
        return result
    }

    func changeOnboardingStatusFalse() {
        Defaults[\.onboardingStatus] = false
    }
}

// MARK: - MockShowOnboardingRepositoryImpl

final class MockShowOnboardingRepositoryImpl: OnboardingRepository {

    // MARK: - Function

    func shouldShowOnboarding() -> Bool {
        return true
    }
    
    func changeOnboardingStatusFalse() {
        // Do Nothing.
    }
}

// MARK: - MockHideOnboardingRepositoryImpl

final class MockHideOnboardingRepositoryImpl: OnboardingRepository {

    // MARK: - Function

    func shouldShowOnboarding() -> Bool {
        return false
    }
    
    func changeOnboardingStatusFalse() {
        // Do Nothing.
    }
}

// MARK: - Factory

struct OnboardingRepositoryFactory {
    static func create() -> OnboardingRepository {
        return OnboardingRepositoryImpl()
    }
}

struct MockShowOnboardingRepositoryFactory {
    static func create() -> OnboardingRepository {
        return MockShowOnboardingRepositoryImpl()
    }
}

struct MockHideOnboardingRepositoryFactory {
    static func create() -> OnboardingRepository {
        return MockHideOnboardingRepositoryImpl()
    }
}
