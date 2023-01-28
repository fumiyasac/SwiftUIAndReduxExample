//
//  RecentNewsCarouselViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

// MARK: - ViewObject

struct RecentNewsCarouselViewObject: Identifiable, Equatable {

    // MARK: - Property
    
    let id: Int
    let thumbnailUrl: URL?
    let title: String
    let newsCategory: String
    let publishedAt: String

    // MARK: - Equatable

    static func == (lhs: RecentNewsCarouselViewObject, rhs: RecentNewsCarouselViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}

struct GroupedRecentNewsCarouselViewObject: Identifiable {

    // MARK: - Property

    let id: UUID
    let recentNewsCarouselViewObjects: [RecentNewsCarouselViewObject]
}
