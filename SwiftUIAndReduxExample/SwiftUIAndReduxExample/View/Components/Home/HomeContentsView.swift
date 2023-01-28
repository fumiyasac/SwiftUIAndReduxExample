//
//  HomeContentsView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/29.
//

import SwiftUI

struct HomeContentsView: View {

    // MARK: - Property

    private let campaignBannerCarouselViewObjects: [CampaignBannerCarouselViewObject]
    private let recentNewsCarouselViewObjects: [RecentNewsCarouselViewObject]
    private let featuredTopicsCarouselViewObjects: [FeaturedTopicsCarouselViewObject]
    private let trendArticlesGridViewObjects: [TrendArticlesGridViewObject]
    private let pickupPhotosGridViewObjects: [PickupPhotosGridViewObject]

    // MARK: - Initializer

    init(
        campaignBannerCarouselViewObjects: [CampaignBannerCarouselViewObject],
        recentNewsCarouselViewObjects: [RecentNewsCarouselViewObject],
        featuredTopicsCarouselViewObjects: [FeaturedTopicsCarouselViewObject],
        trendArticlesGridViewObjects: [TrendArticlesGridViewObject],
        pickupPhotosGridViewObjects: [PickupPhotosGridViewObject]
    ) {
        self.campaignBannerCarouselViewObjects = campaignBannerCarouselViewObjects
        self.recentNewsCarouselViewObjects = recentNewsCarouselViewObjects
        self.featuredTopicsCarouselViewObjects = featuredTopicsCarouselViewObjects
        self.trendArticlesGridViewObjects = trendArticlesGridViewObjects
        self.pickupPhotosGridViewObjects = pickupPhotosGridViewObjects
    }

    // MARK: - Body

    var body: some View {
        // 各Sectionに該当するView要素に表示に必要なViewObjectを反映する
        ScrollView {
            // (1) 季節の特集コンテンツ一覧
            HomeCommonSectionView(
                title: "季節の特集コンテンツ一覧",
                subTitle: "Introduce seasonal shopping and features."
            )
            CampaignBannerCarouselView(
                campaignBannerCarouselViewObjects: campaignBannerCarouselViewObjects
            )
            // (2) 最新のおしらせ
            HomeCommonSectionView(
                title: "最新のおしらせ",
                subTitle: "Let's Check Here for App-only Notifications."
            )
            RecentNewsCarouselView(
                recentNewsCarouselViewObjects: recentNewsCarouselViewObjects
            )
            // (3) 特集掲載店舗
            HomeCommonSectionView(
                title: "特集掲載店舗",
                subTitle: "Please Teach Us Your Favorite Gourmet."
            )
            FeaturedTopicsCarouselView(
                featuredTopicsCarouselViewObjects: featuredTopicsCarouselViewObjects
            )
            // (4) トレンド記事紹介
            HomeCommonSectionView(
                title: "トレンド記事紹介",
                subTitle: "Memorial Articles about Special Season."
            )
            TrendArticlesGridView(
                trendArticlesGridViewObjects: trendArticlesGridViewObjects
            )
            // (5) ピックアップ写真集
            HomeCommonSectionView(
                title: "ピックアップ写真集",
                subTitle: "Let's Enjoy Pickup Gourmet Photo Archives."
            )
            PickupPhotosGridView(
                pickupPhotosGridViewObjects: pickupPhotosGridViewObjects
            )
        }
    }
}
