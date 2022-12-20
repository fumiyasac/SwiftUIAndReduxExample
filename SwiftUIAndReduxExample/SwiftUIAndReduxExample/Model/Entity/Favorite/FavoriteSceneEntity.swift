//
//  FavoriteSceneEntity.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/20.
//

import Foundation

struct FavoriteSceneEntity: Hashable, Decodable {

    let id: Int
    let photoUrl: String
    let author: String
    let title: String
    let category: String
    let shopName: String
    let comment: String
    let publishedAt: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case photoUrl = "photo_url"
        case author
        case title
        case category
        case shopName = "shop_name"
        case comment
        case publishedAt = "published_at"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.photoUrl = try container.decode(String.self, forKey: .photoUrl)
        self.author = try container.decode(String.self, forKey: .author)
        self.title = try container.decode(String.self, forKey: .title)
        self.category = try container.decode(String.self, forKey: .category)
        self.shopName = try container.decode(String.self, forKey: .shopName)
        self.comment = try container.decode(String.self, forKey: .comment)
        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FavoriteSceneEntity, rhs: FavoriteSceneEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
