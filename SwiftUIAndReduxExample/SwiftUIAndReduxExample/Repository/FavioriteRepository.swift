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

// MARK: - Factory

struct FavioriteRepositoryFactory {
    static func create() -> FavioriteRepository {
        return FavioriteRepositoryImpl()
    }
}
