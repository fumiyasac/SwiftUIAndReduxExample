//
//  CampaignBannerCarouselViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

// MARK: - ViewObject

struct CampaignBannerCarouselViewObject: Identifiable, Equatable {

    // MARK: - Property

    let id: Int
    let bannerContentsId: Int
    let bannerUrl: URL?

    // MARK: - Equatable

    static func == (lhs: CampaignBannerCarouselViewObject, rhs: CampaignBannerCarouselViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}
