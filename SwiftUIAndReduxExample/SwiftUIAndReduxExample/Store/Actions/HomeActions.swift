//
//  HomeActions.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/12.
//

import Foundation

// MARK: - Struct

struct RequestHomeSectionsAction: Action {}

struct ShowHomeSectionsAction: Action {

    // MARK: - typealias

    // MEMO: 受け取ったResponseを格納するためのTypealiasを定義する
    typealias HomeResponse = (
        campaignBanners: [CampaignBannerEntity],
        featuredTopics: [FeaturedTopicEntity],
        recentNews: [RecentNewsEntity],
        trendArticles: [TrendArticleEntity],
        pickupPhotos: [PickupPhotoEntity]
    )

    let homeResponse: HomeResponse
}
