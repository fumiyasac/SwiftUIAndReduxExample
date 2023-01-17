//
//  FeaturedTopicsResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/11.
//

import Foundation

// MEMO: 特集コンテンツ一覧表示用のAPIレスポンス定義
struct FeaturedTopicsResponse: Decodable, Equatable {

    let result: [FeaturedTopicEntity]

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: [FeaturedTopicEntity]) {
        self.result = result
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: FeaturedTopicsResponse, rhs: FeaturedTopicsResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
