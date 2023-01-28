//
//  FavoritePhotosCardViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

// MARK: - ViewObject

struct FavoritePhotosCardViewObject: Identifiable {
    let id: Int
    let photoUrl: URL?
    let author: String
    let title: String
    let category: String
    let shopName: String
    let comment: String
    let publishedAt: String
}
