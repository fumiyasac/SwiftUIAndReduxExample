//
//  TrendArticleEntity.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/11.
//

import Foundation

struct TrendArticleEntity: Hashable, Decodable {

    let id: Int
    let thumbnailUrl: String
    let title: String
    let introduction: String
    let publishedAt: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case thumbnailUrl = "thumbnail_url"
        case title
        case introduction
        case publishedAt = "published_at"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
        self.title = try container.decode(String.self, forKey: .title)
        self.introduction = try container.decode(String.self, forKey: .introduction)
        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TrendArticleEntity, rhs: TrendArticleEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
