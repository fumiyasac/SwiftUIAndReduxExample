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
        state.campaignBanners = action.campaignBannerEntities
        state.recentNews = action.recentNewsEntities
        state.featuredTopics = action.featuredTopicEntities
        state.trendArticles = action.trendArticleEntities
        state.pickupPhotos = action.pickupPhotoEntities
        // MEMO: 画面表示ハンドリング用
        state.isLoading = false
        state.isError = false
    case _ as FailureHomeAction:
        state.isLoading = false
        state.isError = true
    // TODO: 画面ダイアログ表示用のcaseも入れること！
    default:
        break
    }
    return state
}
