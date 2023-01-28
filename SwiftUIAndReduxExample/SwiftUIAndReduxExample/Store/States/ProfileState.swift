//
//  ProfileState.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/23.
//

import Foundation

struct ProfileState: ReduxState, Equatable {

    // MARK: - Property

    // MEMO: 読み込み中状態
    var isLoading: Bool = false
    // MEMO: エラー状態
    var isError: Bool = false

    // MEMO: Profile画面で利用する情報として必要なViewObject等の情報
    var backgroundImageUrl: String?
    var profilePersonalViewObject: ProfilePersonalViewObject?
    var profileSelfIntroductionViewObject: ProfileSelfIntroductionViewObject?
    var profilePointsAndHistoryViewObject: ProfilePointsAndHistoryViewObject?
    var profileSocialMediaViewObject: ProfileSocialMediaViewObject?
    var profileInformationViewObject: ProfileInformationViewObject?

    // MARK: - Equatable

    static func == (lhs: ProfileState, rhs: ProfileState) -> Bool {
        return lhs.isLoading == rhs.isLoading
            && lhs.isError == rhs.isError
            && lhs.backgroundImageUrl == rhs.backgroundImageUrl
            && lhs.profilePersonalViewObject == rhs.profilePersonalViewObject
            && lhs.profileSelfIntroductionViewObject == rhs.profileSelfIntroductionViewObject
            && lhs.profileSocialMediaViewObject == rhs.profileSocialMediaViewObject
            && lhs.profilePointsAndHistoryViewObject == rhs.profilePointsAndHistoryViewObject
            && lhs.profileInformationViewObject == rhs.profileInformationViewObject
    }
}
