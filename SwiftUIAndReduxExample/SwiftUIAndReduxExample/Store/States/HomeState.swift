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

    // MEMO: Home画面で利用する情報として必要なViewObject情報
    // ※ このコードではViewObjectとView表示要素のComponentが1:1対応となる想定で作っています。
    var campaignBannerCarouselViewObjects: [CampaignBannerCarouselViewObject] = []
    var recentNewsCarouselViewObjects: [RecentNewsCarouselViewObject] = []
    var featuredTopicsCarouselViewObjects: [FeaturedTopicsCarouselViewObject] = []
    var trendArticlesGridViewObjects: [TrendArticlesGridViewObject] = []
    var pickupPhotosGridViewObjects: [PickupPhotosGridViewObject] = []
    
    // MARK: - Equatable

    static func == (lhs: HomeState, rhs: HomeState) -> Bool {
        return lhs.isLoading == rhs.isLoading
        && lhs.isError == rhs.isError
        && lhs.campaignBannerCarouselViewObjects == rhs.campaignBannerCarouselViewObjects
        && lhs.recentNewsCarouselViewObjects == rhs.recentNewsCarouselViewObjects
        && lhs.featuredTopicsCarouselViewObjects == rhs.featuredTopicsCarouselViewObjects
        && lhs.trendArticlesGridViewObjects == rhs.trendArticlesGridViewObjects
        && lhs.pickupPhotosGridViewObjects == rhs.pickupPhotosGridViewObjects
    }
}
