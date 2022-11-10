//
//  CampaignBannerEntity.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/17.
//

import Foundation

struct CampaignBannerEntity: Hashable, Decodable {

    let id: Int
    let bannerContentsId: Int
    let bannerUrl: String
    let title: String
    let caption: String
    let announcementAt: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case bannerContentsId = "banner_contents_id"
        case bannerUrl = "banner_url"
        case title
        case caption
        case announcementAt = "announcement_at"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.bannerContentsId = try container.decode(Int.self, forKey: .bannerContentsId)
        self.bannerUrl = try container.decode(String.self, forKey: .bannerUrl)
        self.title = try container.decode(String.self, forKey: .title)
        self.caption = try container.decode(String.self, forKey: .caption)
        self.announcementAt = try container.decode(String.self, forKey: .announcementAt)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: CampaignBannerEntity, rhs: CampaignBannerEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
