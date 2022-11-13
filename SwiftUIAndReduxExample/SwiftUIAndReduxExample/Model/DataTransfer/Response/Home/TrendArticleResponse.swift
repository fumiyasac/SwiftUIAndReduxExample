//
//  TrendArticleResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/11.
//

import Foundation

// MEMO: トレンド入り記事一覧表示用のAPIレスポンス定義
struct TrendArticleResponse: HomeResponse, Decodable, Equatable {

    let result: [TrendArticleEntity]

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: [TrendArticleEntity]) {
        self.result = result
    }

    // JSONの配列内の要素を取得する → JSONの配列内の要素にある値をDecodeして初期化する
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.result = try container.decode([TrendArticleEntity].self, forKey: .result)
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: TrendArticleResponse, rhs: TrendArticleResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
