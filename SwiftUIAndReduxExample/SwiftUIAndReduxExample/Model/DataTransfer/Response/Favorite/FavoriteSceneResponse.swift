//
//  FavoriteSceneResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/20.
//

import Foundation

// MEMO: お気に入り一覧表示用のAPIレスポンス定義
struct FavoriteSceneResponse: FavoriteResponse, Decodable, Equatable {
    
    let result: [FavoriteSceneEntity]

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: [FavoriteSceneEntity]) {
        self.result = result
    }

    // JSONの配列内の要素を取得する → JSONの配列内の要素にある値をDecodeして初期化する
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.result = try container.decode([FavoriteSceneEntity].self, forKey: .result)
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: FavoriteSceneResponse, rhs: FavoriteSceneResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
