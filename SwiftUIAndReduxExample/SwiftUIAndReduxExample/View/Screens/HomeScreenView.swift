//
//  HomeScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI

struct HomeScreenView: View {

    // MARK: - Redux

    @EnvironmentObject var store: Store<AppState>

    struct Props {
        // ✨ Immutableに扱うProperty 👉 画面状態管理用
        let isLoading: Bool
        let isError: Bool
        // ✨ Immutableに扱うProperty 👉 画面表示要素用
        let campaignBanners: [CampaignBannerEntity]
        let featuredTopics: [FeaturedTopicEntity]
        let recentNews: [RecentNewsEntity]
        let trendArticles: [TrendArticleEntity]
        let pickupPhotos: [PickupPhotoEntity]
        // ✨ Action発行用のClosure
        let requestHome: () -> Void
        let retryHome: () -> Void
    }

    private func mapStateToProps(state: HomeState) -> Props {
        Props(
            isLoading: state.isLoading,
            isError: state.isError,
            campaignBanners: state.campaignBanners,
            featuredTopics: state.featuredTopics,
            recentNews: state.recentNews,
            trendArticles: state.trendArticles,
            pickupPhotos: state.pickupPhotos,
            requestHome: {
                store.dispatch(action: RequestHomeAction())
            },
            retryHome: {
                store.dispatch(action: RequestHomeAction())
            }
        )
    }

    // MARK: - body

    var body: some View {
        // 該当画面で利用するState(ここではHomeState)をこの画面用のPropsにマッピングする
        let props = mapStateToProps(state: store.state.homeState)
        // 画面用のPropsに応じた画面要素表示処理を実行する
        NavigationStack {
            Group {
                if props.isLoading {
                    ExecutingConnectionView()
                } else if props.isError {
                    ConnectionErrorView(tapButtonAction: props.retryHome)
                } else {
                    showHomeScreen(props: props)
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: props.requestHome)
        }
    }
    
    // MARK: - Private Function
    
    // @ViewBuilderを利用してViewを出し分けています
    // 参考: https://yanamura.hatenablog.com/entry/2019/09/05/150849
    @ViewBuilder
    private func showHomeScreen(props: Props) -> some View {
        // Propsの値を表示用のViewObjectにマッピングし直す
        let campaignBannersCarouselViewObjects = mapToCampaignBannersCarouselViewObjects(props: props)
        let recentNewsCarouselViewObjects = mapToRecentNewsCarouselViewObjects(props: props)
        let featuredTopicsCarouselViewObjects = mapToFeaturedTopicsCarouselViewObjects(props: props)
        let trendArticlesGridViewObjects = mapToTrendArticlesGridViewObjects(props: props)
        let pickupPhotoGridViewObjects = mapToPickupPhotosGridViewObjects(props: props)
        // 各Sectionに該当するView要素に表示に必要なViewObjectを反映する
        ScrollView {
            // (1) 季節の特集コンテンツ一覧
            HomeCommonSectionView(
                title: "季節の特集コンテンツ一覧",
                subTitle: "Introduce seasonal shopping and features."
            )
            CampaignBannerCarouselView(
                campaignBannersCarouselViewObjects: campaignBannersCarouselViewObjects
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
                pickupPhotosGridViewObjects: pickupPhotoGridViewObjects
            )
        }
    }

    private func mapToCampaignBannersCarouselViewObjects(props: Props) -> [CampaignBannerCarouselViewObject] {
        return props.campaignBanners.map {
            CampaignBannerCarouselViewObject(
                id: $0.id,
                bannerContentsId: $0.bannerContentsId,
                bannerUrl: URL(string: $0.bannerUrl) ?? nil
            )
        }
    }

    private func mapToRecentNewsCarouselViewObjects(props: Props) -> [RecentNewsCarouselViewObject] {
        return props.recentNews.map {
            RecentNewsCarouselViewObject(
                id: $0.id,
                thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                title: $0.title,
                newsCategory: $0.newsCategory,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
            )
        }
    }

    private func mapToFeaturedTopicsCarouselViewObjects(props: Props) -> [FeaturedTopicsCarouselViewObject] {
        return props.featuredTopics.map {
            FeaturedTopicsCarouselViewObject(
                id: $0.id,
                rating: $0.rating,
                thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                title: $0.title,
                caption: $0.caption,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
            )
        }
    }

    private func mapToTrendArticlesGridViewObjects(props: Props) -> [TrendArticlesGridViewObject] {
        return props.trendArticles.map {
            TrendArticlesGridViewObject(
                id: $0.id,
                thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                title: $0.title,
                introduction:$0.introduction,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
            )
        }
    }

    private func mapToPickupPhotosGridViewObjects(props: Props) -> [PickupPhotosGridViewObject] {
        return props.pickupPhotos.map {
            PickupPhotosGridViewObject(
                id: $0.id,
                title: $0.title,
                caption: $0.caption,
                photoUrl: URL(string: $0.photoUrl) ?? nil,
                photoWidth: CGFloat($0.photoWidth),
                photoHeight: CGFloat($0.photoHeight)
            )
        }
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
        guard let result = try? JSONDecoder().decode([CampaignBannerEntity].self, from: data) else {
            fatalError()
        }
        return CampaignBannersResponse(result: result)
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
        guard let result = try? JSONDecoder().decode([FeaturedTopicEntity].self, from: data) else {
            fatalError()
        }
        return FeaturedTopicsResponse(result: result)
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
        guard let result = try? JSONDecoder().decode([RecentNewsEntity].self, from: data) else {
            fatalError()
        }
        return RecentNewsResponse(result: result)
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
        guard let result = try? JSONDecoder().decode([TrendArticleEntity].self, from: data) else {
            fatalError()
        }
        return TrendArticleResponse(result: result)
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
        guard let result = try? JSONDecoder().decode([PickupPhotoEntity].self, from: data) else {
            fatalError()
        }
        return PickupPhotoResponse(result: result)
    }
}

// MARK: - Preview

//struct HomeScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeScreenView()
//    }
//}
