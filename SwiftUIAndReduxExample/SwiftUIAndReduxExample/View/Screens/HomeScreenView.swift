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

// MARK: - Preview

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        // Success時の画面表示
        let homeSuccessStore = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                homeMockSuccessMiddleware()
            ]
        )
        HomeScreenView()
            .environmentObject(homeSuccessStore)
            .previewDisplayName("Home Secreen Success Preview")
        // Failure時の画面表示
        let homeFailureStore = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                homeMockFailureMiddleware()
            ]
        )
        HomeScreenView()
            .environmentObject(homeFailureStore)
            .previewDisplayName("Home Secreen Failure Preview")
    }
}
