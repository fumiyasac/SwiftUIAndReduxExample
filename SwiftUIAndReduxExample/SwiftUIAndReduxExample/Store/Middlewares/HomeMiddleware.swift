//
//  HomeMiddleware.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/17.
//

import Foundation

// MARK: - Typealias

// 👉 要素表示で利用するレスポンスをまとめるためのtypealias
// ※ convertHomeSectionResponse(homeResponses: [HomeResponse])の戻り値
typealias HomeSectionResponse = (
    campaignBannersResponse: CampaignBannersResponse,
    recentNewsResponse: RecentNewsResponse,
    featuredTopicsResponse: FeaturedTopicsResponse,
    trendArticleResponse: TrendArticleResponse,
    pickupPhotoResponse: PickupPhotoResponse
)

// MARK: - Function (Production)

// APIリクエスト結果に応じたActionを発行する
// ※テストコードの場合は検証用のhomeMiddlewareのものに差し替える想定
func homeMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case let action as RequestHomeAction:
            // 👉 RequestHomeActionを受け取ったらその後にAPIリクエスト処理を実行する
            requestHomeSections(action: action, dispatch: dispatch)
            default:
                break
        }
    }
}

// MARK: - Private Function (Production)

// 👉 APIリクエスト処理を実行するためのメソッド
// ※テストコードの場合は想定するStubデータを返すものに差し替える想定
private func requestHomeSections(action: RequestHomeAction, dispatch: @escaping Dispatcher) {
    Task { @MainActor in
        do {
            let homeResponses = try await HomeRepositoryFactory.create().getHomeResponses()
            let homeSectionResponses = try convertHomeSectionResponse(homeResponses: homeResponses)
            // お望みのレスポンスが取得できた場合は成功時のActionを発行する
            dispatch(
                SuccessHomeAction(
                    campaignBannerEntities: homeSectionResponses.campaignBannersResponse.result,
                    recentNewsEntities: homeSectionResponses.recentNewsResponse.result,
                    featuredTopicEntities: homeSectionResponses.featuredTopicsResponse.result,
                    trendArticleEntities: homeSectionResponses.trendArticleResponse.result,
                    pickupPhotoEntities: homeSectionResponses.pickupPhotoResponse.result
                )
            )
            dump(homeResponses)
        } catch APIError.error(let message) {
            // 通信エラーないしはお望みのレスポンスが取得できなかった場合は成功時のActionを発行する
            dispatch(FailureHomeAction())
            print(message)
        }
    }
}

// MARK: - Function (Mock for Success)

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

// MARK: - Function (Mock for Failure)

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
        let homeResponses = try await MockSuccessHomeRepositoryFactory.create().getHomeResponses()
        let homeSectionResponses = try convertHomeSectionResponse(homeResponses: homeResponses)
        dispatch(
            SuccessHomeAction(
                campaignBannerEntities: homeSectionResponses.campaignBannersResponse.result,
                recentNewsEntities: homeSectionResponses.recentNewsResponse.result,
                featuredTopicEntities: homeSectionResponses.featuredTopicsResponse.result,
                trendArticleEntities: homeSectionResponses.trendArticleResponse.result,
                pickupPhotoEntities: homeSectionResponses.pickupPhotoResponse.result
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

// MARK: - Private Function (Convert from [HomeResponse])

private func convertHomeSectionResponse(homeResponses: [HomeResponse]) throws -> HomeSectionResponse {
    var campaignBannersResponse: CampaignBannersResponse?
    var recentNewsResponse: RecentNewsResponse?
    var featuredTopicsResponse: FeaturedTopicsResponse?
    var trendArticleResponse: TrendArticleResponse?
    var pickupPhotoResponse: PickupPhotoResponse?
    // HomeResponseの中から該当するレスポンスを取り出す
    for homeResponse in homeResponses {
        if let targetCampaignBannersResponse = homeResponse as? CampaignBannersResponse {
            campaignBannersResponse = targetCampaignBannersResponse
        }
        if let targetRecentNewsResponse = homeResponse as? RecentNewsResponse {
            recentNewsResponse = targetRecentNewsResponse
        }
        if let targetFeaturedTopicsResponse = homeResponse as? FeaturedTopicsResponse {
            featuredTopicsResponse = targetFeaturedTopicsResponse
        }
        if let targetTrendArticleResponse = homeResponse as? TrendArticleResponse {
            trendArticleResponse = targetTrendArticleResponse
        }
        if let targetPickupPhotoResponse = homeResponse as? PickupPhotoResponse {
            pickupPhotoResponse = targetPickupPhotoResponse
        }
    }
    // MEMO: どれか1つのレスポンスでも欠けている様な状態ならばAPIErrorとして取り扱う
    guard let campaignBannersResponse = campaignBannersResponse,
          let recentNewsResponse = recentNewsResponse,
          let featuredTopicsResponse = featuredTopicsResponse,
          let trendArticleResponse = trendArticleResponse,
          let pickupPhotoResponse = pickupPhotoResponse else {
        throw APIError.error(message: "No HomeSectionResponse exists.")
    }
    return HomeSectionResponse(
        campaignBannersResponse: campaignBannersResponse,
        recentNewsResponse: recentNewsResponse,
        featuredTopicsResponse: featuredTopicsResponse,
        trendArticleResponse: trendArticleResponse,
        pickupPhotoResponse: pickupPhotoResponse
    )
}
