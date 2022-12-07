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
            let pickupPhotoResponse = getPickupPhotoResponse()
            let pickupPhotoGridViewObjects = pickupPhotoResponse.result
                .map {
                    PickupPhotosGridViewObject(
                        id: $0.id,
                        title: $0.title,
                        caption: $0.caption,
                        photoUrl: URL(string: $0.photoUrl) ?? nil,
                        photoWidth: CGFloat($0.photoWidth),
                        photoHeight: CGFloat($0.photoHeight)
                    )
                }

            ScrollView {
                Group {
                    HomeCommonSectionView(title: "季節の特集コンテンツ一覧", subTitle: "Introduce seasonal shopping and features.")
                    CampaignBannerCarouselView(campaignBannersCarouselViewObjects: campaignBannerCarouselViewObjects)
                }
                Group {
                    HomeCommonSectionView(title: "ピックアップ写真集", subTitle: "Let's Enjoy Pickup Gourmet Photo Archives.")
                    PickupPhotosGridView(pickupPhotosGridViewObjects: pickupPhotoGridViewObjects)
                }
            }
            .navigationBarTitle(Text("Home"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Private Function

    private func getPickupPhotoResponse() -> PickupPhotoResponse {
        guard let path = Bundle.main.path(forResource: "pickup_photos", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let pickupPhotoResponse = try? JSONDecoder().decode(PickupPhotoResponse.self, from: data) else {
            fatalError()
        }
        return pickupPhotoResponse
    }

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
