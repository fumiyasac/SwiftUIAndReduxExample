//
//  ProfileAnnoucementResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/21.
//

import Foundation

// MEMO: プロフィール画面内の運営からのお知らせ部分のAPIレスポンス定義
struct ProfileAnnoucementResponse: ProfileResponse, Decodable, Equatable {

    let result: [ProfileAnnoucementEntity]

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: [ProfileAnnoucementEntity]) {
        self.result = result
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: ProfileAnnoucementResponse, rhs: ProfileAnnoucementResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
