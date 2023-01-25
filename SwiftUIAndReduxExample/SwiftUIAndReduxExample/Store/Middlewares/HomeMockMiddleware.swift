//
//  HomeMockMiddleware.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/25.
//

import Foundation

// テストコードで利用するAPIリクエスト結果に応じたActionを発行する（Success時）
func homeMockSuccessMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case let action as RequestHomeAction:
            // 👉 RequestHomeActionを受け取ったらその後にAPIリクエスト処理を実行する
            mockSuccessRequestHomeSections(action: action, dispatch: dispatch)
            default:
                break
        }
    }
}

// テストコードで利用するAPIリクエスト結果に応じたActionを発行する（Failure時）
func homeMockFailureMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case let action as RequestHomeAction:
            // 👉 RequestHomeActionを受け取ったらその後にAPIリクエスト処理を実行する
            mockFailureRequestHomeSections(action: action, dispatch: dispatch)
            default:
                break
        }
    }
}

// MARK: - Private Function (Dispatch Action Success/Failure)

// 👉 成功時のAPIリクエストを想定した処理を実行するためのメソッド
private func mockSuccessRequestHomeSections(action: RequestHomeAction, dispatch: @escaping Dispatcher) {
    Task { @MainActor in
        let _ = try await Task.sleep(for: .seconds(0.64))
        dispatch(
            SuccessHomeAction(
                campaignBannerEntities: getCampaignBannersResponse().result,
                recentNewsEntities: getRecentNewsResponse().result,
                featuredTopicEntities: getFeaturedTopicsResponse().result,
                trendArticleEntities: getTrendArticleResponse().result,
                pickupPhotoEntities: getPickupPhotoResponse().result
            )
        )
    }
}

// 👉 失敗時のAPIリクエストを想定した処理を実行するためのメソッド
private func mockFailureRequestHomeSections(action: RequestHomeAction, dispatch: @escaping Dispatcher) {
    Task { @MainActor in
        let _ = try await Task.sleep(for: .seconds(0.64))
        dispatch(FailureHomeAction())
    }
}

// MARK: - Private Function (Get Response JSON)

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
