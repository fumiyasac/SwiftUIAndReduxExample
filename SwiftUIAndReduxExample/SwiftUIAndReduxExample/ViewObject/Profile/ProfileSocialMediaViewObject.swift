//
//  ProfileSocialMediaViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

struct ProfileSocialMediaViewObject: Identifiable, Equatable {

    // MARK: - Property

    let id: Int
    let twitterUrl: URL?
    let facebookUrl: URL?
    let instagramUrl: URL?

    // MARK: - Equatable

    static func == (lhs: ProfileSocialMediaViewObject, rhs: ProfileSocialMediaViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}
