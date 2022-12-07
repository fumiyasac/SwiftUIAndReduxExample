//
//  PickupPhotoEntity.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/11.
//

import Foundation

struct PickupPhotoEntity: Hashable, Decodable {

    let id: Int
    let photoUrl: String
    let photoWidth: Int
    let photoHeight: Int
    let title: String
    let caption: String
    let publishedAt: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case photoUrl = "photo_url"
        case photoWidth = "photo_width"
        case photoHeight = "photo_height"
        case title
        case caption
        case publishedAt = "published_at"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.photoUrl = try container.decode(String.self, forKey: .photoUrl)
        self.photoWidth = try container.decode(Int.self, forKey: .photoWidth)
        self.photoHeight = try container.decode(Int.self, forKey: .photoHeight)
        self.title = try container.decode(String.self, forKey: .title)
        self.caption = try container.decode(String.self, forKey: .caption)
        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PickupPhotoEntity, rhs: PickupPhotoEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
