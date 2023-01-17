//
//  HomeRepository.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/18.
//

import Foundation

// MARK: - Protocol

protocol HomeRepository {
    func getHomeResponses() async throws -> [HomeResponse]
}

final class HomeRepositoryImpl: HomeRepository {

    // MARK: - Function

    func getHomeResponses() async throws -> [HomeResponse] {
        var responses: [HomeResponse] = []
        // 👉 エンドポイントの並び順を担保しながらの並列処理を実行する
        // 参考: https://zenn.dev/akkyie/articles/swift-concurrency#%E3%82%BF%E3%82%B9%E3%82%AF%E3%82%B0%E3%83%AB%E3%83%BC%E3%83%97-(task-group)
        try await withThrowingTaskGroup(of: HomeResponse.self, body: { group in
            group.addTask {
                return try await ApiClientManager.shared.getCampaignBanners()
            }
            group.addTask {
                return try await ApiClientManager.shared.getRecentNews()
            }
            group.addTask {
                return try await ApiClientManager.shared.getFeaturedTopics()
            }
            group.addTask {
                return try await ApiClientManager.shared.getTrendArticles()
            }
            group.addTask {
                return try await ApiClientManager.shared.getPickupPhotos()
            }
            // 👉 endpointsの配列に格納されている順番でレスポンスデータが格納される
            for try await response in group {
                responses.append(response)
            }
            // 👉 エラーハンドリング処理（例. ここではレスポンスが全て空だった場合はエラーとみなす）
            if responses.isEmpty {
                throw APIError.error(message: "All Response about Home is Empty.")
            }
        })
        return responses
    }
}

// MARK: - Factory

struct HomeRepositoryFactory {
    static func create() -> HomeRepository {
        return HomeRepositoryImpl()
    }
}
