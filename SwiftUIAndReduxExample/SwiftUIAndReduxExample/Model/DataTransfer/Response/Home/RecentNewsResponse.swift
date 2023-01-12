//
//  RecentNewsResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/11.
//

import Foundation

// MEMO: 最新ニュース一覧表示用のAPIレスポンス定義
struct RecentNewsResponse: HomeResponse, Decodable, Equatable {

    let result: [RecentNewsEntity]

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: [RecentNewsEntity]) {
        self.result = result
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: RecentNewsResponse, rhs: RecentNewsResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
