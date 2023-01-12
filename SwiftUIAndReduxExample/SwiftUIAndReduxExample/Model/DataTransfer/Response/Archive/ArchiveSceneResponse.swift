//
//  ArchiveSceneResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/11.
//

import Foundation

// MEMO: お気に入り一覧表示用のAPIレスポンス定義
struct ArchiveSceneResponse: ArchiveResponse, Decodable, Equatable {
    
    let result: [ArchiveSceneEntity]

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: [ArchiveSceneEntity]) {
        self.result = result
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: ArchiveSceneResponse, rhs: ArchiveSceneResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
