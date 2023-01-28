//
//  TrendArticlesGridViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

// MARK: - ViewObject

struct TrendArticlesGridViewObject: Identifiable, Equatable {

    // MARK: - Property

    let id: Int
    let thumbnailUrl: URL?
    let title: String
    let introduction: String
    let publishedAt: String

    // MARK: - Equatable

    static func == (lhs: TrendArticlesGridViewObject, rhs: TrendArticlesGridViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}
