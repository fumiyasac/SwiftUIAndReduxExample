//
//  RequestArchiveRepository.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/04.
//

import Foundation

// MARK: - Protocol

protocol RequestArchiveRepository {
    func getArchiveResponse(keyword: String, category: String) async throws -> ArchiveResponse
}

final class RequestArchiveRepositoryImpl: RequestArchiveRepository {

    // MARK: - Function

    func getArchiveResponse(keyword: String, category: String) async throws -> ArchiveResponse {
        return try await ApiClientManager.shared.getAchiveImages(keyword: keyword, category: category)
    }
}

// MARK: - MockSuccessRequestArchiveRepositoryImpl

final class MockSuccessRequestArchiveRepositoryImpl: RequestArchiveRepository {

    // MARK: - Function

    func getArchiveResponse(keyword: String, category: String) async throws -> ArchiveResponse {
        let filteredResult = getArchiveSceneResponse().result
            .filter { $0.dishName.contains(keyword) || $0.shopName.contains(keyword)  || $0.introduction.contains(keyword) }
            .filter { $0.category == category }
        return ArchiveSceneResponse(result: filteredResult)
    }

    // MARK: - Private Function

    private func getArchiveSceneResponse() -> ArchiveSceneResponse {
        guard let path = Bundle.main.path(forResource: "achive_images", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ArchiveSceneEntity].self, from: data) else {
            fatalError()
        }
        return ArchiveSceneResponse(result: result)
    }
}

// MARK: - Factory

struct RequestArchiveRepositoryFactory {
    static func create() -> RequestArchiveRepository {
        return RequestArchiveRepositoryImpl()
    }
}

struct MockSuccessRequestArchiveRepositoryFactory {
    static func create() -> RequestArchiveRepository {
        return MockSuccessRequestArchiveRepositoryImpl()
    }
}
