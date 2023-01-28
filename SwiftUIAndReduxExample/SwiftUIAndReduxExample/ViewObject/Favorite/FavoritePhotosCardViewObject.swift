//
//  FavoritePhotosCardViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

// MARK: - ViewObject

struct FavoritePhotosCardViewObject: Identifiable, Equatable {
    
    // MARK: - Property

    let id: Int
    let photoUrl: URL?
    let author: String
    let title: String
    let category: String
    let shopName: String
    let comment: String
    let publishedAt: String

    // MARK: - Equatable

    static func == (lhs: FavoritePhotosCardViewObject, rhs: FavoritePhotosCardViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}
