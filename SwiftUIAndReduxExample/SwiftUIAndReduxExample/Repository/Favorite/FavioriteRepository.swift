//
//  FavioriteRepository.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/19.
//

import Foundation

// MARK: - Protocol

protocol FavioriteRepository {
    func getFavioriteResponse() async throws -> FavoriteResponse
}

final class FavioriteRepositoryImpl: FavioriteRepository {

    // MARK: - Function

    func getFavioriteResponse() async throws -> FavoriteResponse {
        return try await ApiClientManager.shared.getFavoriteScenes()
    }    
}

// MARK: - MockSuccessFavioriteRepositoryImpl

final class MockSuccessFavioriteRepositoryImpl: FavioriteRepository {

    // MARK: - Function

    func getFavioriteResponse() async throws -> FavoriteResponse {
        return getFavoriteSceneResponse()
    }

    // MARK: - Private Function

    private func getFavoriteSceneResponse() -> FavoriteSceneResponse {
        guard let path = Bundle.main.path(forResource: "favorite_scenes", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([FavoriteSceneEntity].self, from: data) else {
            fatalError()
        }
        return FavoriteSceneResponse(result: result)
    }
}

// MARK: - Factory

struct FavioriteRepositoryFactory {
    static func create() -> FavioriteRepository {
        return FavioriteRepositoryImpl()
    }
}

struct MockSuccessFavioriteRepositoryFactory {
    static func create() -> FavioriteRepository {
        return MockSuccessFavioriteRepositoryImpl()
    }
}
