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
            let campaignBannersResponse = getCampaignBannersResponse()
            let campaignBannerCarouselViewObjects = campaignBannersResponse.result
                .map {
                    CampaignBannerCarouselViewObject(
                        id: $0.id,
                        bannerContentsId: $0.bannerContentsId,
                        bannerUrl: URL(string: $0.bannerUrl) ?? nil
                    )
                }
            let recentNewsResponse = getRecentNewsResponse()
            let recentNewsCarouselViewObjects = recentNewsResponse.result
                .map {
                    RecentNewsCarouselViewObject(
                        id: $0.id,
                        thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                        title: $0.title,
                        newsCategory: $0.newsCategory,
                        publishedAt: $0.publishedAt
                    )
                }
            let trendArticleResponse = getTrendArticleResponse()
            let trendArticlesGridViewObjects = trendArticleResponse.result
                .map {
                    TrendArticlesGridViewObject(
                        id: $0.id,
                        thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                        title: $0.title,
                        introduction:$0.introduction,
                        publishedAt: $0.publishedAt
                    )
                }
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
            ScrollView {
                HomeCommonSectionView(title: "季節の特集コンテンツ一覧", subTitle: "Introduce seasonal shopping and features.")
                CampaignBannerCarouselView(campaignBannersCarouselViewObjects: campaignBannerCarouselViewObjects)
                HomeCommonSectionView(title: "最新のおしらせ", subTitle: "Let's Check Here for App-only Notifications.")
                RecentNewsCarouselView(recentNewsCarouselViewObjects: recentNewsCarouselViewObjects)
                HomeCommonSectionView(title: "トレンド記事紹介", subTitle: "Memorial Articles about Special Season.")
                TrendArticlesGridView(trendArticlesGridViewObjects: trendArticlesGridViewObjects)
                HomeCommonSectionView(title: "ピックアップ写真集", subTitle: "Let's Enjoy Pickup Gourmet Photo Archives.")
                PickupPhotosGridView(pickupPhotosGridViewObjects: pickupPhotoGridViewObjects)
            }
            .navigationBarTitle(Text("Home"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Private Function
    
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
}

// MARK: - Preview

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
