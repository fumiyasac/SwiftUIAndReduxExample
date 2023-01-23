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

    // MEMO: Profile画面で利用する情報として必要なEntity情報
    var profilePersonal: ProfilePersonalEntity?
    var profileAnnoucements: [ProfileAnnoucementEntity] = []
    var profileComments: [ProfileCommentEntity] = []
    var profileRecentFavorites: [ProfileRecentFavoriteEntity] = []

    // MARK: - Equatable

    static func == (lhs: ProfileState, rhs: ProfileState) -> Bool {
        return lhs.isLoading == rhs.isLoading
            && lhs.isError == rhs.isError
            && lhs.profilePersonal == rhs.profilePersonal
            && lhs.profileAnnoucements == rhs.profileAnnoucements
            && lhs.profileComments == rhs.profileComments
            && lhs.profileRecentFavorites == rhs.profileRecentFavorites
    }
}
