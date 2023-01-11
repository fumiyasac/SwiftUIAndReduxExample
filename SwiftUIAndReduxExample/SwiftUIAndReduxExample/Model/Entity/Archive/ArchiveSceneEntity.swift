//
//  ArchiveSceneEntity.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/27.
//

import Foundation

struct ArchiveSceneEntity: Hashable, Decodable {

    let id: Int
    let photoUrl: String
    let category: String
    let dishName: String
    let shopName: String
    let introduction: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case photoUrl = "photo_url"
        case category
        case dishName = "dish_name"
        case shopName = "shop_name"
        case introduction
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.photoUrl = try container.decode(String.self, forKey: .photoUrl)
        self.category = try container.decode(String.self, forKey: .category)
        self.dishName = try container.decode(String.self, forKey: .dishName)
        self.shopName = try container.decode(String.self, forKey: .shopName)
        self.introduction = try container.decode(String.self, forKey: .introduction)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ArchiveSceneEntity, rhs: ArchiveSceneEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
