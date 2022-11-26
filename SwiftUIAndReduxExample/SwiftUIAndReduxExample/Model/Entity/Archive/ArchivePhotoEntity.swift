//
//  ArchivePhotoEntity.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/27.
//

import Foundation

struct ArchivePhotoEntity: Hashable, Decodable {

    let id: Int
    let photoUrl: String
    let title: String
    let caption: String
    let detail: String
    let category: String
    let hashtags: [String]
    let publishedAt: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case photoUrl = "photo_url"
        case title
        case caption
        case detail
        case category
        case hashtags
        case publishedAt = "published_at"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.photoUrl = try container.decode(String.self, forKey: .photoUrl)
        self.title = try container.decode(String.self, forKey: .title)
        self.caption = try container.decode(String.self, forKey: .caption)
        self.detail = try container.decode(String.self, forKey: .detail)
        self.category = try container.decode(String.self, forKey: .category)
        self.hashtags = try container.decode([String].self, forKey: .hashtags)
        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ArchivePhotoEntity, rhs: ArchivePhotoEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
