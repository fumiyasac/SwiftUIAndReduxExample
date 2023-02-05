//
//  OnboardingReducer.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/05.
//

import Foundation

func onboardingReducer(_ state: OnboardingState, _ action: Action) -> OnboardingState {
    var state = state
    switch action {
    case _ as ShowOnboardingAction:
        state.isInitial = true
    case _ as CloseOnboardingAction:
        state.isInitial = false
    default:
        break
    }
    return state
}
