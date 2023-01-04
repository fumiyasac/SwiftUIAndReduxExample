//
//  HomeScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI

struct HomeScreenView: View {
    
    // MARK: - body
    
    var body: some View {
        NavigationView {
            ScrollView {
                // (1) 季節の特集コンテンツ一覧
                HomeCommonSectionView(
                    title: "季節の特集コンテンツ一覧",
                    subTitle: "Introduce seasonal shopping and features."
                )
                CampaignBannerCarouselView(
                    campaignBannersCarouselViewObjects: getCampaignBannersCarouselViewObjects()
                )
                // (2) 最新のおしらせ
                HomeCommonSectionView(
                    title: "最新のおしらせ",
                    subTitle: "Let's Check Here for App-only Notifications."
                )
                RecentNewsCarouselView(
                    recentNewsCarouselViewObjects: getRecentNewsCarouselViewObjects()
                )
                // (3) 特集掲載店舗
                HomeCommonSectionView(
                    title: "特集掲載店舗",
                    subTitle: "Please Teach Us Your Favorite Gourmet."
                )
                FeaturedTopicsCarouselView(
                    featuredTopicsCarouselViewObjects: getFeaturedTopicsCarouselViewObjects()
                )
                // (4) トレンド記事紹介
                HomeCommonSectionView(
                    title: "トレンド記事紹介",
                    subTitle: "Memorial Articles about Special Season."
                )
                TrendArticlesGridView(
                    trendArticlesGridViewObjects: getTrendArticlesGridViewObjects()
                )
                // (5) ピックアップ写真集
                HomeCommonSectionView(
                    title: "ピックアップ写真集",
                    subTitle: "Let's Enjoy Pickup Gourmet Photo Archives."
                )
                PickupPhotosGridView(
                    pickupPhotosGridViewObjects: getPickupPhotosGridViewObjects()
                )
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: HomeScreenView Extension

extension HomeScreenView {

    // MARK: - Private Function

    private func getCampaignBannersCarouselViewObjects() -> [CampaignBannerCarouselViewObject] {
        let campaignBannersResponse = getCampaignBannersResponse()
        let campaignBannerCarouselViewObjects = campaignBannersResponse.result
            .map {
                CampaignBannerCarouselViewObject(
                    id: $0.id,
                    bannerContentsId: $0.bannerContentsId,
                    bannerUrl: URL(string: $0.bannerUrl) ?? nil
                )
            }
        return campaignBannerCarouselViewObjects
    }

    private func getCampaignBannersResponse() -> CampaignBannersResponse {
        guard let path = Bundle.main.path(forResource: "campaign_banners", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let campaignBannersResponse = try? JSONDecoder().decode(CampaignBannersResponse.self, from: data) else {
            fatalError()
        }
        return campaignBannersResponse
    }

    private func getFeaturedTopicsCarouselViewObjects() -> [FeaturedTopicsCarouselViewObject] {
        let featuredTopicsResponse = getFeaturedTopicsResponse()
        let featuredTopicsCarouselViewObjects = featuredTopicsResponse.result
            .map {
                FeaturedTopicsCarouselViewObject(
                    id: $0.id,
                    rating: $0.rating,
                    thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                    title: $0.title,
                    caption: $0.caption,
                    publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
                )
            }
        return featuredTopicsCarouselViewObjects
    }
    
    private func getFeaturedTopicsResponse() -> FeaturedTopicsResponse {
        guard let path = Bundle.main.path(forResource: "featured_topics", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let featuredTopicsResponse = try? JSONDecoder().decode(FeaturedTopicsResponse.self, from: data) else {
            fatalError()
        }
        return featuredTopicsResponse
    }

    private func getRecentNewsCarouselViewObjects() -> [RecentNewsCarouselViewObject] {
        let recentNewsResponse = getRecentNewsResponse()
        let recentNewsCarouselViewObjects = recentNewsResponse.result
            .map {
                RecentNewsCarouselViewObject(
                    id: $0.id,
                    thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                    title: $0.title,
                    newsCategory: $0.newsCategory,
                    publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
                )
            }
        return recentNewsCarouselViewObjects
    }

    private func getRecentNewsResponse() -> RecentNewsResponse {
        guard let path = Bundle.main.path(forResource: "recent_news", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let recentNewsResponse = try? JSONDecoder().decode(RecentNewsResponse.self, from: data) else {
            fatalError()
        }
        return recentNewsResponse
    }

    private func getTrendArticlesGridViewObjects() -> [TrendArticlesGridViewObject] {
        let trendArticleResponse = getTrendArticleResponse()
        let trendArticlesGridViewObjects = trendArticleResponse.result
            .map {
                TrendArticlesGridViewObject(
                    id: $0.id,
                    thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                    title: $0.title,
                    introduction:$0.introduction,
                    publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
                )
            }
        return trendArticlesGridViewObjects
    }

    private func getTrendArticleResponse() -> TrendArticleResponse {
        guard let path = Bundle.main.path(forResource: "trend_articles", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let trendArticleResponse = try? JSONDecoder().decode(TrendArticleResponse.self, from: data) else {
            fatalError()
        }
        return trendArticleResponse
    }

    private func getPickupPhotosGridViewObjects() -> [PickupPhotosGridViewObject] {
        let pickupPhotoResponse = getPickupPhotoResponse()
        let pickupPhotoGridViewObjects = pickupPhotoResponse.result
            .map {
                PickupPhotosGridViewObject(
                    id: $0.id,
                    title: $0.title,
                    caption: $0.caption,
                    photoUrl: URL(string: $0.photoUrl) ?? nil,
                    photoWidth: CGFloat($0.photoWidth),
                    photoHeight: CGFloat($0.photoHeight)
                )
            }
        return pickupPhotoGridViewObjects
    }

    private func getPickupPhotoResponse() -> PickupPhotoResponse {
        guard let path = Bundle.main.path(forResource: "pickup_photos", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let pickupPhotoResponse = try? JSONDecoder().decode(PickupPhotoResponse.self, from: data) else {
            fatalError()
        }
        return pickupPhotoResponse
    }
}

// MARK: - Preview

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
