//
//  ProfilePersonalResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/21.
//

import Foundation

// MEMO: プロフィール表示情報用のAPIレスポンス定義
struct ProfilePersonalResponse: ProfileResponse, Decodable, Equatable {

    let result: ProfilePersonalEntity

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: ProfilePersonalEntity) {
        self.result = result
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: ProfilePersonalResponse, rhs: ProfilePersonalResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
