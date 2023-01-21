//
//  ProfileCommentResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/21.
//

import Foundation

// MEMO: プロフィール画面内のコメント部分のAPIレスポンス定義
struct ProfileCommentResponse: ProfileResponse, Decodable, Equatable {

    let result: [ProfileCommentEntity]

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: [ProfileCommentEntity]) {
        self.result = result
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: ProfileCommentResponse, rhs: ProfileCommentResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
