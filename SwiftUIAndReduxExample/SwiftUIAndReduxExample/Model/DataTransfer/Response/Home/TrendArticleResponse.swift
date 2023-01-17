//
//  TrendArticleResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/11.
//

import Foundation

// MEMO: トレンド入り記事一覧表示用のAPIレスポンス定義
struct TrendArticleResponse: Decodable, Equatable {

    let result: [TrendArticleEntity]

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: [TrendArticleEntity]) {
        self.result = result
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: TrendArticleResponse, rhs: TrendArticleResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
