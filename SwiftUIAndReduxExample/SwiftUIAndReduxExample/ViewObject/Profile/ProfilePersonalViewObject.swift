//
//  ProfilePersonalViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

struct ProfilePersonalViewObject: Identifiable, Equatable {

    // MARK: - Property

    let id: Int
    let nickname: String
    let createdAt: String
    let avatarUrl: String

    // MARK: - Equatable

    static func == (lhs: ProfilePersonalViewObject, rhs: ProfilePersonalViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}
