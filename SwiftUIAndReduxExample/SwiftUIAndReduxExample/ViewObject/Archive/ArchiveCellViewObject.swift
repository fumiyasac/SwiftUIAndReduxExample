//
//  ArchiveCellViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/30.
//

import Foundation

// MARK: - ViewObject

struct ArchiveCellViewObject: Identifiable, Equatable {
    
    // MARK: - Property
    
    let id: Int
    let photoUrl: URL?
    let category: String
    let dishName: String
    let shopName: String
    let introduction: String
    // MEMO: ハートマークの状態を示すための変数
    var shouldFavorite: Bool = false

    // MARK: - Equatable

    mutating func toggleShouldFavorite() {
        shouldFavorite = !shouldFavorite
    }

    // MARK: - Equatable

    static func == (lhs: ArchiveCellViewObject, rhs: ArchiveCellViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}
