//
//  ProfileRecentFavoriteResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/21.
//

import Foundation

// MEMO: プロフィール画面内の最近のお気に入り部分のAPIレスポンス定義
struct ProfileRecentFavoriteResponse: ProfileResponse, Decodable, Equatable {

    let result: [ProfileRecentFavoriteEntity]

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: [ProfileRecentFavoriteEntity]) {
        self.result = result
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: ProfileRecentFavoriteResponse, rhs: ProfileRecentFavoriteResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
