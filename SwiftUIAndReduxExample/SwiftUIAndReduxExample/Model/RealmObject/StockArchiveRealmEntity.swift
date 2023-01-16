//
//  StockArchiveRealmEntity.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/16.
//

import Foundation
import RealmSwift

final class StockArchiveRealmEntity: Object {
    
    // MARK: - Property

    @objc dynamic var id: Int = 0
    @objc dynamic var photoUrl: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var dishName: String = ""
    @objc dynamic var shopName: String = ""
    @objc dynamic var introduction: String = ""

    // MEMO: PrimaryKey部分の設定対応
    override static func primaryKey() -> String? {
        return "id"
    }
}
