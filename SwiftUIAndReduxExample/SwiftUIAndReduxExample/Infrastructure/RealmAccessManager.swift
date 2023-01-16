//
//  RealmAccessManager.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/12.
//

import Foundation
import RealmSwift

// MARK: - Protocol

protocol RealmAccessProtocol {

    // StockArchiveRealmEntityオブジェクトの一覧を取得する
    func getAllStockArchiveRealmEntities() -> [StockArchiveRealmEntity]

    // 新規にStockArchiveRealmEntityオブジェクトを追加する
    func saveStockArchiveRealmEntity(_ stockArchiveRealmEntity: StockArchiveRealmEntity)

    // 既存のStockArchiveRealmEntityオブジェクトを削除する
    func deleteStockArchiveRealmEntity(_ stockArchiveRealmEntity: StockArchiveRealmEntity)
}

final class RealmAccessManager {

    // MEMO: 下記の様なイメージでRealmを利用するにあたって基本的な操作となる部分を定義する
    // 補足: このサンプル実装では、アプリ内部にBundleさせているJsonから追加したデータをRealmObjectにMappingして検索画面のために利用する

    // MARK: - Singleton Instance

    static let shared = RealmAccessManager()

    // MARK: - Properies

    private let schemaConfig = Realm.Configuration(schemaVersion: 0)

    // MARK: - Function

    // 引数で与えられた型に該当するRealmオブジェクトを全件取得する
    func getAllObjects<T: Object>(_ realmObjectType: T.Type) -> Results<T>? {
        let realm = try! Realm(configuration: schemaConfig)
        return realm.objects(T.self)
    }

    // 該当するRealmオブジェクトを追加する
    func save<T: Object>(_ realmObject: T) {
        let realm = try! Realm(configuration: schemaConfig)
        try! realm.write() {
            realm.add(realmObject)
        }
    }

    // 該当するRealmオブジェクトを削除する
    func delete<T: Object>(_ realmObject: T) {
        let realm = try! Realm(configuration: schemaConfig)
        try! realm.write() {
            realm.delete(realmObject)
        }
    }
}

// MARK: - RealmAccessProtocol

extension RealmAccessManager: RealmAccessProtocol {

    func getAllStockArchiveRealmEntities() -> [StockArchiveRealmEntity] {
        if let stockArchiveRealmEntities = getAllObjects(StockArchiveRealmEntity.self) {
            return Array(stockArchiveRealmEntities)
        } else {
            return []
        }
    }
    
    func saveStockArchiveRealmEntity(_ stockArchiveRealmEntity: StockArchiveRealmEntity) {
        save(stockArchiveRealmEntity)
    }
    
    func deleteStockArchiveRealmEntity(_ stockArchiveRealmEntity: StockArchiveRealmEntity) {
        delete(stockArchiveRealmEntity)
    }
}
