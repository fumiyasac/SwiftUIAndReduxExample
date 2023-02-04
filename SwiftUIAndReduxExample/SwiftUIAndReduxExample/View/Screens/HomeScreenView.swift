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

    private struct Props {
        // Immutableに扱うProperty 👉 画面状態管理用
        let isLoading: Bool
        let isError: Bool
        // Immutableに扱うProperty 👉 画面表示要素用
        let campaignBannerCarouselViewObjects: [CampaignBannerCarouselViewObject]
        let recentNewsCarouselViewObjects: [RecentNewsCarouselViewObject]
        let reaturedTopicsCarouselViewObjects: [FeaturedTopicsCarouselViewObject]
        let trendArticlesGridViewObjects: [TrendArticlesGridViewObject]
        let pickupPhotosGridViewObjects: [PickupPhotosGridViewObject]
        // Action発行用のClosure
        let requestHome: () -> Void
        let retryHome: () -> Void
    }

    private func mapStateToProps(state: HomeState) -> Props {
        Props(
            isLoading: state.isLoading,
            isError: state.isError,
            campaignBannerCarouselViewObjects: state.campaignBannerCarouselViewObjects,
            recentNewsCarouselViewObjects: state.recentNewsCarouselViewObjects,
            reaturedTopicsCarouselViewObjects: state.reaturedTopicsCarouselViewObjects,
            trendArticlesGridViewObjects: state.trendArticlesGridViewObjects,
            pickupPhotosGridViewObjects: state.pickupPhotosGridViewObjects,
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

        // 表示に必要な値をPropsから取得する
        let isLoading = mapToIsLoading(props: props)
        let isError = mapToIsError(props: props)

        // 画面用のPropsに応じた画面要素表示処理を実行する
        NavigationStack {
            Group {
                if isLoading {
                    // ローディング画面を表示
                    ExecutingConnectionView()
                } else if isError {
                    // エラー画面を表示
                    ConnectionErrorView(tapButtonAction: props.retryHome)
                } else {
                    // HomeContentsView(それぞれのSection要素を集約している画面要素)を表示
                    showHomeContentsView(props: props)
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            // 画面が表示された際に一度だけAPIリクエストを実行する形にしています。
            .onFirstAppear(props.requestHome)
        }
    }

    // MARK: - Private Function

    @ViewBuilder
    private func showHomeContentsView(props: Props) -> some View {
        // Propsから各Section表示用のViewObjectを取り出す
        let campaignBannerCarouselViewObjects = mapToCampaignBannerCarouselViewObjects(props: props)
        let recentNewsCarouselViewObjects = mapToRecentNewsCarouselViewObjects(props: props)
        let featuredTopicsCarouselViewObjects = mapToFeaturedTopicsCarouselViewObjects(props: props)
        let trendArticlesGridViewObjects = mapToTrendArticlesGridViewObjects(props: props)
        let pickupPhotoGridViewObjects = mapToPickupPhotosGridViewObjects(props: props)
        // 各Sectionに該当するView要素に表示に必要なViewObjectを反映する
        HomeContentsView(
            campaignBannerCarouselViewObjects: campaignBannerCarouselViewObjects,
            recentNewsCarouselViewObjects: recentNewsCarouselViewObjects,
            featuredTopicsCarouselViewObjects: featuredTopicsCarouselViewObjects,
            trendArticlesGridViewObjects: trendArticlesGridViewObjects,
            pickupPhotosGridViewObjects: pickupPhotoGridViewObjects
        )
    }

    private func mapToCampaignBannerCarouselViewObjects(props: Props) -> [CampaignBannerCarouselViewObject] {
        return props.campaignBannerCarouselViewObjects
    }

    private func mapToRecentNewsCarouselViewObjects(props: Props) -> [RecentNewsCarouselViewObject] {
        return props.recentNewsCarouselViewObjects
    }

    private func mapToFeaturedTopicsCarouselViewObjects(props: Props) -> [FeaturedTopicsCarouselViewObject] {
        return props.reaturedTopicsCarouselViewObjects
    }

    private func mapToTrendArticlesGridViewObjects(props: Props) -> [TrendArticlesGridViewObject] {
        return props.trendArticlesGridViewObjects
    }

    private func mapToPickupPhotosGridViewObjects(props: Props) -> [PickupPhotosGridViewObject] {
        return props.pickupPhotosGridViewObjects
    }

    private func mapToIsError(props: Props) -> Bool {
        return props.isError
    }

    private func mapToIsLoading(props: Props) -> Bool {
        return props.isLoading
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
