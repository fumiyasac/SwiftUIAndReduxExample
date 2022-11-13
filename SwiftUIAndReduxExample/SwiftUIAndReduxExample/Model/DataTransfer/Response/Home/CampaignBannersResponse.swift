//
//  CampaignBannersResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/17.
//

import Foundation

// MEMO: キャンペーンバナー一覧表示用のAPIレスポンス定義
struct CampaignBannersResponse: HomeResponse, Decodable, Equatable {
    
    let result: [CampaignBannerEntity]

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: [CampaignBannerEntity]) {
        self.result = result
    }

    // JSONの配列内の要素を取得する → JSONの配列内の要素にある値をDecodeして初期化する
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.result = try container.decode([CampaignBannerEntity].self, forKey: .result)
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: CampaignBannersResponse, rhs: CampaignBannersResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
