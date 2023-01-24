//
//  ProfileMiddleware.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/24.
//

import Foundation

// 👉 要素表示で利用するレスポンスをまとめるためのtypealias
// ※ convertProfileSectionResponse(profileResponses: [ProfileResponse])の戻り値
typealias ProfileSectionResponse = (
    profilePersonalResponse: ProfilePersonalResponse,
    profileAnnoucementResponse: ProfileAnnoucementResponse,
    profileCommentResponse: ProfileCommentResponse,
    profileRecentFavoriteResponse: ProfileRecentFavoriteResponse
)

// APIリクエスト結果に応じたActionを発行する
// ※テストコードの場合は検証用のhomeMiddlewareのものに差し替える想定
func profileMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            case let action as RequestProfileAction:
            // 👉 RequestHomeActionを受け取ったらその後にAPIリクエスト処理を実行する
            requestProfileSections(action: action, dispatch: dispatch)
            default:
                break
        }
    }
}

// 👉 APIリクエスト処理を実行するためのメソッド
// ※テストコードの場合は想定するStubデータを返すものに差し替える想定
private func requestProfileSections(action: RequestProfileAction, dispatch: @escaping Dispatcher) {
    Task { @MainActor in
        do {
            let profileResponses = try await ProfileRepositoryFactory.create().getProfileResponses()
            let profileSectionResponses = try convertProfileSectionResponse(profileResponses: profileResponses)
            // お望みのレスポンスが取得できた場合は成功時のActionを発行する
            dispatch(
                SuccessProfileAction(
                    profilePersonalEntity: profileSectionResponses.profilePersonalResponse.result,
                    profileAnnoucementEntities: profileSectionResponses.profileAnnoucementResponse.result,
                    profileCommentEntities: profileSectionResponses.profileCommentResponse.result,
                    profileRecentFavoriteEntities: profileSectionResponses.profileRecentFavoriteResponse.result
                )
            )
            dump(profileResponses)
        } catch APIError.error(let message) {
            // 通信エラーないしはお望みのレスポンスが取得できなかった場合は成功時のActionを発行する
            dispatch(FailureProfileAction())
            print(message)
        }
    }
}

private func convertProfileSectionResponse(profileResponses: [ProfileResponse]) throws -> ProfileSectionResponse {
    var profilePersonalResponse: ProfilePersonalResponse?
    var profileAnnoucementResponse: ProfileAnnoucementResponse?
    var profileCommentResponse: ProfileCommentResponse?
    var profileRecentFavoriteResponse: ProfileRecentFavoriteResponse?
    // ProfileResponseの中から該当するレスポンスを取り出す
    for profileResponse in profileResponses {
        if let targetProfilePersonalResponse = profileResponse as? ProfilePersonalResponse {
            profilePersonalResponse = targetProfilePersonalResponse
        }
        if let targetProfileAnnoucementResponse = profileResponse as? ProfileAnnoucementResponse {
            profileAnnoucementResponse = targetProfileAnnoucementResponse
        }
        if let targetProfileCommentResponse = profileResponse as? ProfileCommentResponse {
            profileCommentResponse = targetProfileCommentResponse
        }
        if let targetProfileRecentFavoriteResponse = profileResponse as? ProfileRecentFavoriteResponse {
            profileRecentFavoriteResponse = targetProfileRecentFavoriteResponse
        }
    }
    // MEMO: どれか1つのレスポンスでも欠けている様な状態ならばAPIErrorとして取り扱う
    guard let profilePersonalResponse = profilePersonalResponse,
          let profileAnnoucementResponse = profileAnnoucementResponse,
          let profileCommentResponse = profileCommentResponse,
          let profileRecentFavoriteResponse = profileRecentFavoriteResponse else {
        throw APIError.error(message: "No ProfileSectionResponse exists.")
    }
    return ProfileSectionResponse(
        profilePersonalResponse: profilePersonalResponse,
        profileAnnoucementResponse: profileAnnoucementResponse,
        profileCommentResponse: profileCommentResponse,
        profileRecentFavoriteResponse: profileRecentFavoriteResponse
    )
}
