//
//  HomeActions.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/12.
//

import Foundation

struct RequestHomeAction: Action {}

struct SuccessHomeAction: Action {
    let campaignBannerEntities: [CampaignBannerEntity]
    let recentNewsEntities: [RecentNewsEntity]
    let featuredTopicEntities: [FeaturedTopicEntity]
    let trendArticleEntities: [TrendArticleEntity]
    let pickupPhotoEntities: [PickupPhotoEntity]
}

struct FailureHomeAction: Action {}

struct ShowGuidanceAction: Action {}

struct CloseGuidanceAction: Action {}
