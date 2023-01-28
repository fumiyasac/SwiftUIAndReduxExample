//
//  ProfilePointsAndHistoryViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

struct ProfilePointsAndHistoryViewObject: Identifiable, Equatable {

    // MARK: - Property

    let id: Int
    let profileViewCount: Int
    let articlePostCount: Int
    let totalPageViewCount: Int
    let totalAvailablePoints: Int
    let totalUseCouponCount: Int
    let totalVisitShopCount: Int

    // MARK: - Equatable

    static func == (lhs: ProfilePointsAndHistoryViewObject, rhs: ProfilePointsAndHistoryViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}
