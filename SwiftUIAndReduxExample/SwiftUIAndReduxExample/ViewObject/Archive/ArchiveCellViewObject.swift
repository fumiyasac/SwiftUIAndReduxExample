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
    // MEMO: 表示処理時点でのハートマークの状態を示す
    var isStored: Bool = false

    // MARK: - Equatable

    static func == (lhs: ArchiveCellViewObject, rhs: ArchiveCellViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}
