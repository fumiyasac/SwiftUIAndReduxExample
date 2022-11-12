//
//  HomeState.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/12.
//

import Foundation

struct HomeState: ReduxState {
    // MEMO: Home画面で利用する情報として必要なEntity情報
    // ※ このコードではEntityとView表示要素のComponentが1:1対応となる想定で作っています。
    var campaignBanners: [CampaignBannerEntity] = []
    var featuredTopics: [FeaturedTopicEntity] = []
    var recentNews: [RecentNewsEntity] = []
    var trendArticles: [TrendArticleEntity] = []
    var pickupPhotos: [PickupPhotoEntity] = []
}
