//
//  FeaturedTopicsCarouselViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

// MARK: - ViewObject

struct FeaturedTopicsCarouselViewObject: Identifiable, Equatable {

    // MARK: - Property

    let id: Int
    let rating: Double
    let thumbnailUrl: URL?
    let title: String
    let caption: String
    let publishedAt: String

    // MARK: - Equatable

    static func == (lhs: FeaturedTopicsCarouselViewObject, rhs: FeaturedTopicsCarouselViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}
