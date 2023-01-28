//
//  ProfileSelfIntroductionViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

struct ProfileSelfIntroductionViewObject: Identifiable, Equatable {

    // MARK: - Property

    let id: Int
    let introduction: String

    // MARK: - Equatable

    static func == (lhs: ProfileSelfIntroductionViewObject, rhs: ProfileSelfIntroductionViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}
