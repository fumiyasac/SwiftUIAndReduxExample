//
//  ProfileCommentEntity.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/21.
//

import Foundation

struct ProfileCommentEntity: Hashable, Decodable {

    let id: Int
    let emotion: String
    let title: String
    let publishedAt: String
    let comment: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case emotion
        case title
        case publishedAt = "published_at"
        case comment
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.emotion = try container.decode(String.self, forKey: .emotion)
        self.title = try container.decode(String.self, forKey: .title)
        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
        self.comment = try container.decode(String.self, forKey: .comment)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ProfileCommentEntity, rhs: ProfileCommentEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
