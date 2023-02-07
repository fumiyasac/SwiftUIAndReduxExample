//
//  HomeReducer.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/12.
//

import Foundation

func homeReducer(_ state: HomeState, _ action: Action) -> HomeState {
    var state = state
    switch action {
    case _ as RequestHomeAction:
        state.isLoading = true
        state.isError = false
    case let action as SuccessHomeAction:
        // MEMO: 画面要素表示用
        state.campaignBannerCarouselViewObjects = action.campaignBannerEntities.map {
            CampaignBannerCarouselViewObject(
                id: $0.id,
                bannerContentsId: $0.bannerContentsId,
                bannerUrl: URL(string: $0.bannerUrl) ?? nil
            )
        }
        state.recentNewsCarouselViewObjects = action.recentNewsEntities.map {
            RecentNewsCarouselViewObject(
                id: $0.id,
                thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                title: $0.title,
                newsCategory: $0.newsCategory,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
            )
        }
        state.featuredTopicsCarouselViewObjects = action.featuredTopicEntities.map {
            FeaturedTopicsCarouselViewObject(
                id: $0.id,
                rating: $0.rating,
                thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                title: $0.title,
                caption: $0.caption,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
            )
        }
        state.trendArticlesGridViewObjects = action.trendArticleEntities.map {
            TrendArticlesGridViewObject(
                id: $0.id,
                thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                title: $0.title,
                introduction:$0.introduction,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
            )
        }
        state.pickupPhotosGridViewObjects = action.pickupPhotoEntities.map {
            PickupPhotosGridViewObject(
                id: $0.id,
                title: $0.title,
                caption: $0.caption,
                photoUrl: URL(string: $0.photoUrl) ?? nil,
                photoWidth: CGFloat($0.photoWidth),
                photoHeight: CGFloat($0.photoHeight)
            )
        }
        // MEMO: 画面表示ハンドリング用
        state.isLoading = false
        state.isError = false
    case _ as FailureHomeAction:
        state.isLoading = false
        state.isError = true
    default:
        break
    }
    return state
}
