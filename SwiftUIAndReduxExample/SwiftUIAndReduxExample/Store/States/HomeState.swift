//
//  HomeState.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/12.
//

import Foundation

struct HomeState: ReduxState, Equatable {

    // MARK: - Property

    // MEMO: 読み込み中¥状態
    var isLoading: Bool = false
    // MEMO: エラー状態
    var isError: Bool = false

    // MEMO: Home画面で利用する情報として必要なEntity情報
    // ※ このコードではEntityとView表示要素のComponentが1:1対応となる想定で作っています。
    var campaignBanners: [CampaignBannerEntity] = []
    var featuredTopics: [FeaturedTopicEntity] = []
    var recentNews: [RecentNewsEntity] = []
    var trendArticles: [TrendArticleEntity] = []
    var pickupPhotos: [PickupPhotoEntity] = []
    
    // MARK: - Equatable

    static func == (lhs: HomeState, rhs: HomeState) -> Bool {
        return lhs.isLoading == rhs.isLoading
        && lhs.isError == rhs.isError
        && lhs.campaignBanners == rhs.campaignBanners
        && lhs.featuredTopics == rhs.featuredTopics
        && lhs.recentNews == rhs.recentNews
        && lhs.trendArticles == rhs.trendArticles
        && lhs.pickupPhotos == rhs.pickupPhotos
    }
}
