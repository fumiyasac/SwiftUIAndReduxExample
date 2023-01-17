//
//  PickupPhotoResponse.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/11.
//

import Foundation

// MEMO: ピックアップ写真一覧表示用のAPIレスポンス定義
struct PickupPhotoResponse: Decodable, Equatable {

    let result: [PickupPhotoEntity]

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case result
    }

    // MARK: - Initializer

    init(result: [PickupPhotoEntity]) {
        self.result = result
    }

    // MARK: - Equatable

    // MEMO: Equatableプロトコルに適合させるための処理

    static func == (lhs: PickupPhotoResponse, rhs: PickupPhotoResponse) -> Bool {
        return lhs.result == rhs.result
    }
}
