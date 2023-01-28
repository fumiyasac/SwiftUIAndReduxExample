//
//  RecentNewsCarouselViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

// MARK: - ViewObject

struct GroupedRecentNewsCarouselViewObject: Identifiable {
    let id: UUID
    let recentNewsCarouselViewObjects: [RecentNewsCarouselViewObject]
}

struct RecentNewsCarouselViewObject: Identifiable {
    let id: Int
    let thumbnailUrl: URL?
    let title: String
    let newsCategory: String
    let publishedAt: String
}
