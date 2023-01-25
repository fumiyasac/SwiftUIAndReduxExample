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

// MARK: - HomeRepositoryImpl

final class HomeRepositoryImpl: HomeRepository {

    // MARK: - Function

    func getHomeResponses() async throws -> [HomeResponse] {
        var responses: [HomeResponse] = []
        // 👉 エンドポイントの並び順を担保しながらの並列処理を実行する
        // ※ この場合は特に不要ではあるが、備忘録として実施しています。
        // 参考: https://zenn.dev/akkyie/articles/swift-concurrency#%E3%82%BF%E3%82%B9%E3%82%AF%E3%82%B0%E3%83%AB%E3%83%BC%E3%83%97-(task-group)
        try await withThrowingTaskGroup(of: (Int, HomeResponse).self, body: { group in
            var responseDictionary: [Int: HomeResponse] = [:]
            group.addTask {
                return (0, try await ApiClientManager.shared.getCampaignBanners())
            }
            group.addTask {
                return (1, try await ApiClientManager.shared.getRecentNews())
            }
            group.addTask {
                return (2, try await ApiClientManager.shared.getFeaturedTopics())
            }
            group.addTask {
                return (3, try await ApiClientManager.shared.getTrendArticles())
            }
            group.addTask {
                return (4, try await ApiClientManager.shared.getPickupPhotos())
            }
            // 👉 [Int: HomeResponse]のkey値の順番でレスポンスデータを格納する
            for try await (index, response) in group {
                responseDictionary[index] = response
            }
            for (_, response) in responseDictionary.sorted(by: { $0.key < $1.key }) {
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

final class MockSuccessHomeRepositoryImpl: HomeRepository {
    func getHomeResponses() async throws -> [HomeResponse] {
        return [
            getCampaignBannersResponse(),
            getRecentNewsResponse(),
            getFeaturedTopicsResponse(),
            getTrendArticleResponse(),
            getPickupPhotoResponse()
        ]
    }

    // MARK: - Private Function

    private func getCampaignBannersResponse() -> CampaignBannersResponse {
        guard let path = Bundle.main.path(forResource: "campaign_banners", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([CampaignBannerEntity].self, from: data) else {
            fatalError()
        }
        return CampaignBannersResponse(result: result)
    }

    private func getRecentNewsResponse() -> RecentNewsResponse {
        guard let path = Bundle.main.path(forResource: "recent_news", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([RecentNewsEntity].self, from: data) else {
            fatalError()
        }
        return RecentNewsResponse(result: result)
    }

    private func getFeaturedTopicsResponse() -> FeaturedTopicsResponse {
        guard let path = Bundle.main.path(forResource: "featured_topics", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([FeaturedTopicEntity].self, from: data) else {
            fatalError()
        }
        return FeaturedTopicsResponse(result: result)
    }

    private func getTrendArticleResponse() -> TrendArticleResponse {
        guard let path = Bundle.main.path(forResource: "trend_articles", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([TrendArticleEntity].self, from: data) else {
            fatalError()
        }
        return TrendArticleResponse(result: result)
    }

    private func getPickupPhotoResponse() -> PickupPhotoResponse {
        guard let path = Bundle.main.path(forResource: "pickup_photos", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([PickupPhotoEntity].self, from: data) else {
            fatalError()
        }
        return PickupPhotoResponse(result: result)
    }
}

// MARK: - Factory

struct HomeRepositoryFactory {
    static func create() -> HomeRepository {
        return HomeRepositoryImpl()
    }
}

struct MockSuccessHomeRepositoryFactory {
    static func create() -> HomeRepository {
        return MockSuccessHomeRepositoryImpl()
    }
}
