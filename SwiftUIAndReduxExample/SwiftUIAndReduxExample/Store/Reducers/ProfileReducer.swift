//
//  ProfileReducer.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/24.
//

import Foundation

func profileReducer(_ state: ProfileState, _ action: Action) -> ProfileState {
    var state = state
    switch action {
    case _ as RequestProfileAction:
        state.isLoading = true
        state.isError = false
    case let action as SuccessProfileAction:
        // MEMO: 画面要素表示用
        let profileId = action.profilePersonalEntity.id
        state.backgroundImageUrl = action.profilePersonalEntity.backgroundImageUrl
        state.profilePersonalViewObject = ProfilePersonalViewObject(
            id: profileId,
            nickname: action.profilePersonalEntity.nickname,
            createdAt: action.profilePersonalEntity.createdAt,
            avatarUrl: action.profilePersonalEntity.avatarUrl
        )
        state.profileSelfIntroductionViewObject = ProfileSelfIntroductionViewObject(
            id: profileId,
            introduction: action.profilePersonalEntity.introduction
        )
        state.profilePointsAndHistoryViewObject = ProfilePointsAndHistoryViewObject(
            id: profileId,
            profileViewCount: action.profilePersonalEntity.histories.profileViewCount,
            articlePostCount: action.profilePersonalEntity.histories.articlePostCount,
            totalPageViewCount: action.profilePersonalEntity.histories.totalPageViewCount,
            totalAvailablePoints: action.profilePersonalEntity.histories.totalAvailablePoints,
            totalUseCouponCount: action.profilePersonalEntity.histories.totalUseCouponCount,
            totalVisitShopCount: action.profilePersonalEntity.histories.totalVisitShopCount
        )
        state.profileSocialMediaViewObject = ProfileSocialMediaViewObject(
            id: profileId,
            twitterUrl: action.profilePersonalEntity.socialMedia.twitterUrl,
            facebookUrl: action.profilePersonalEntity.socialMedia.facebookUrl,
            instagramUrl: action.profilePersonalEntity.socialMedia.instagramUrl
        )
        state.profileInformationViewObject = ProfileInformationViewObject(
            id: profileId,
            profileAnnoucementViewObjects: action.profileAnnoucementEntities.map {
                ProfileAnnoucementViewObject(
                    id: $0.id,
                    category: $0.category,
                    title: $0.title,
                    publishedAt: $0.publishedAt,
                    description: $0.description
                )
            },
            profileCommentViewObjects: action.profileCommentEntities.map {
                ProfileCommentViewObject(
                    id: $0.id,
                    emotion: $0.emotion,
                    title: $0.title,
                    publishedAt: $0.publishedAt,
                    comment: $0.comment
                )
            },
            profileRecentFavoriteViewObjects: action.profileRecentFavoriteEntities.map {
                ProfileRecentFavoriteViewObject(
                    id: $0.id,
                    category: $0.category,
                    title: $0.title,
                    publishedAt: $0.publishedAt,
                    description: $0.description
                )
            }
        )
        // MEMO: 画面表示ハンドリング用
        state.isLoading = false
        state.isError = false
    case _ as FailureProfileAction:
        state.isLoading = false
        state.isError = true
    default:
        break
    }
    return state
}
