//
//  CampaignBannerCarouselViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

// MARK: - ViewObject

struct CampaignBannerCarouselViewObject: Identifiable {
    let id: Int
    let bannerContentsId: Int
    let bannerUrl: URL?
}
