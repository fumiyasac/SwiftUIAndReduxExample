//
//  ProfileInformationViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

struct ProfileInformationViewObject: Identifiable, Equatable {

    // MARK: - Property

    let id: Int
    let profileAnnoucementViewObjects: [ProfileAnnoucementViewObject]
    let profileCommentViewObjects: [ProfileCommentViewObject]
    let profileRecentFavoriteViewObjects: [ProfileRecentFavoriteViewObject]

    // MARK: - Equatable

    static func == (lhs: ProfileInformationViewObject, rhs: ProfileInformationViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ProfileAnnoucementViewObject: Identifiable {

    // MARK: - Property

    let id: Int
    let category: String
    let title: String
    let publishedAt: String
    let description: String
}

struct ProfileCommentViewObject: Identifiable {

    // MARK: - Property

    let id: Int
    let emotion: String
    let title: String
    let publishedAt: String
    let comment: String
}

struct ProfileRecentFavoriteViewObject: Identifiable {

    // MARK: - Property

    let id: Int
    let category: String
    let title: String
    let publishedAt: String
    let description: String
}
