//
//  ProfileActions.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/24.
//

import Foundation

struct RequestProfileAction: Action {}

struct SuccessProfileAction: Action {
    let profilePersonalEntity: ProfilePersonalEntity
    let profileAnnoucementEntities: [ProfileAnnoucementEntity]
    var profileCommentEntities: [ProfileCommentEntity]
    var profileRecentFavoriteEntities: [ProfileRecentFavoriteEntity]
}

struct FailureProfileAction: Action {}
