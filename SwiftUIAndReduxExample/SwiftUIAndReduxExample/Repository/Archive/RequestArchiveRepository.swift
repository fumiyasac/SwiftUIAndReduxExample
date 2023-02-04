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

// MARK: - Factory

struct RequestArchiveRepositoryFactory {
    static func create() -> RequestArchiveRepository {
        return RequestArchiveRepositoryImpl()
    }
}
