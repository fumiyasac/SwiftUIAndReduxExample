//
//  ProfileRecentFavoriteEntity.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/21.
//

import Foundation

struct ProfileRecentFavoriteEntity: Hashable, Decodable {

    let id: Int
    let category: String
    let title: String
    let publishedAt: String
    let description: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case category
        case title
        case publishedAt = "published_at"
        case description
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.category = try container.decode(String.self, forKey: .category)
        self.title = try container.decode(String.self, forKey: .title)
        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
        self.description = try container.decode(String.self, forKey: .description)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ProfileRecentFavoriteEntity, rhs: ProfileRecentFavoriteEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
