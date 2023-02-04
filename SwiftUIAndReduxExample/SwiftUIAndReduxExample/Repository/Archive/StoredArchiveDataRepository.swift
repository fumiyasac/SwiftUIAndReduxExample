//
//  StoredArchiveDataRepository.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/04.
//

import Foundation

// MARK: - Protocol

protocol StoredArchiveDataRepository {
    func getAllObjectsFromRealm() -> [StockArchiveRealmEntity]
    func createToRealm(archiveCellViewObject: ArchiveCellViewObject)
    func deleteFromRealm(archiveCellViewObject: ArchiveCellViewObject)
}

final class StoredArchiveDataRepositoryImpl: StoredArchiveDataRepository {

    // MARK: - Function

    func getAllObjectsFromRealm() -> [StockArchiveRealmEntity] {
        if let stockArchiveRealmEntities = RealmAccessManager.shared.getAllObjects(StockArchiveRealmEntity.self) {
            return stockArchiveRealmEntities.map { $0 }
        } else {
            return []
        }
    }

    func createToRealm(archiveCellViewObject: ArchiveCellViewObject) {
        let stockArchiveRealmEntity = convertToRealmObject(archiveCellViewObject: archiveCellViewObject)
        RealmAccessManager.shared.saveStockArchiveRealmEntity(stockArchiveRealmEntity)
    }

    func deleteFromRealm(archiveCellViewObject: ArchiveCellViewObject) {
        if let stockArchiveRealmEntities = RealmAccessManager.shared.getAllObjects(StockArchiveRealmEntity.self),
           let stockArchiveRealmEntity = stockArchiveRealmEntities.map({ $0 }).filter({ $0.id == archiveCellViewObject.id }).first
        {
            RealmAccessManager.shared.deleteStockArchiveRealmEntity(stockArchiveRealmEntity)
        } else {
            fatalError("削除対象のデータは登録されていませんでした。")
        }
    }

    // MARK: - Private Function

    private func convertToRealmObject(archiveCellViewObject: ArchiveCellViewObject) -> StockArchiveRealmEntity {
        let realmObject = StockArchiveRealmEntity()
        realmObject.id = archiveCellViewObject.id
        realmObject.photoUrl = archiveCellViewObject.photoUrl?.absoluteString ?? ""
        realmObject.category = archiveCellViewObject.category
        realmObject.dishName = archiveCellViewObject.dishName
        realmObject.shopName = archiveCellViewObject.shopName
        realmObject.introduction = archiveCellViewObject.introduction
        return realmObject
    }
}

final class MockStoredArchiveDataRepositoryImpl: StoredArchiveDataRepository {

    // MARK: - Property

    // 👉 Mockでは実際にRealmに登録するのではなく、内部のDictionaryで管理する
    private var mockDataStore: [Int : StockArchiveRealmEntity] = [:]

    // MARK: - Function

    func getAllObjectsFromRealm() -> [StockArchiveRealmEntity] {
        return mockDataStore.values.map({ $0 })
    }

    func createToRealm(archiveCellViewObject: ArchiveCellViewObject) {
        mockDataStore[archiveCellViewObject.id] = convertToRealmObject(archiveCellViewObject: archiveCellViewObject)
    }

    func deleteFromRealm(archiveCellViewObject: ArchiveCellViewObject) {
        mockDataStore.removeValue(forKey: archiveCellViewObject.id)
    }

    // MARK: - Private Function

    private func convertToRealmObject(archiveCellViewObject: ArchiveCellViewObject) -> StockArchiveRealmEntity {
        let realmObject = StockArchiveRealmEntity()
        realmObject.id = archiveCellViewObject.id
        realmObject.photoUrl = archiveCellViewObject.photoUrl?.absoluteString ?? ""
        realmObject.category = archiveCellViewObject.category
        realmObject.dishName = archiveCellViewObject.dishName
        realmObject.shopName = archiveCellViewObject.shopName
        realmObject.introduction = archiveCellViewObject.introduction
        return realmObject
    }
}

// MARK: - Factory

struct StoredArchiveDataRepositoryFactory {
    static func create() -> StoredArchiveDataRepository {
        return StoredArchiveDataRepositoryImpl()
    }
}

struct MockStoredArchiveDataRepositoryFactory {
    static func create() -> StoredArchiveDataRepository {
        return MockStoredArchiveDataRepositoryImpl()
    }
}
