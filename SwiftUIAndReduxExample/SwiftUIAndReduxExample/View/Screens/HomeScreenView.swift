//
//  HomeScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI

struct HomeScreenView: View {
    
    // MARK: - body
    
    var body: some View {
        NavigationView {
            let campaignBannersResponse = getCampaignBannersDummyResponse()
            let campaignBannerCarouselViewObjects = campaignBannersResponse.result
                .map {
                    CampaignBannerCarouselViewObject(
                        id: $0.id,
                        bannerContentsId: $0.bannerContentsId,
                        bannerUrl: URL(string: $0.bannerUrl) ?? nil
                    )
                }
            CampaignBannerCarouselView(campaignBannersCarouselViewObjects: campaignBannerCarouselViewObjects)
                .navigationBarTitle(Text("Home"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Private Static Function

    private func getCampaignBannersDummyResponse() -> CampaignBannersResponse {
        guard let path = Bundle.main.path(forResource: "campaign_banners", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let campaignBannersResponse = try? JSONDecoder().decode(CampaignBannersResponse.self, from: data) else {
            fatalError()
        }
        return campaignBannersResponse
    }
}

// MARK: - Preview

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
