//
//  ProfileRepository.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/21.
//

import Foundation

// MARK: - Protocol

protocol ProfileRepository {
    func getProfileResponses() async throws -> [ProfileResponse]
}

final class ProfileRepositoryImpl: ProfileRepository {

    // MARK: - Function

    func getProfileResponses() async throws -> [ProfileResponse] {
        var responses: [ProfileResponse] = []
        // 👉 エンドポイントの並び順を担保しながらの並列処理を実行する
        // ※ この場合は特に不要ではあるが、備忘録として実施しています。
        // 参考: https://zenn.dev/akkyie/articles/swift-concurrency#%E3%82%BF%E3%82%B9%E3%82%AF%E3%82%B0%E3%83%AB%E3%83%BC%E3%83%97-(task-group)
        try await withThrowingTaskGroup(of: (Int, ProfileResponse).self, body: { group in
            var responseDictionary: [Int: ProfileResponse] = [:]
            group.addTask {
                return (0, try await ApiClientManager.shared.getProfilePersonal())
            }
            group.addTask {
                return (1, try await ApiClientManager.shared.getProfileAnnoucement())
            }
            group.addTask {
                return (2, try await ApiClientManager.shared.getProfileComment())
            }
            group.addTask {
                return (3, try await ApiClientManager.shared.getProfileRecentFavorite())
            }
            // 👉 [Int: ProfileResponse]のkey値の順番でレスポンスデータを格納する
            for try await (index, response) in group {
                responseDictionary[index] = response
            }
            for (_, response) in responseDictionary.sorted(by: { $0.key < $1.key }) {
                responses.append(response)
            }
            // 👉 エラーハンドリング処理（例. ここではレスポンスが全て空だった場合はエラーとみなす）
            if responses.isEmpty {
                throw APIError.error(message: "All Response about Profile is Empty.")
            }
        })
        return responses
    }
}

// MARK: - MockSuccessProfileRepositoryImpl

final class MockSuccessProfileRepositoryImpl: ProfileRepository {
    func getProfileResponses() async throws -> [ProfileResponse] {
        return [
            getProfilePersonalResponse(),
            getProfileAnnoucementResponse(),
            getProfileCommentResponse(),
            getProfileRecentFavoriteResponse()
        ]
    }

    // MARK: - Private Function

    private func getProfilePersonalResponse() -> ProfilePersonalResponse {
        guard let path = Bundle.main.path(forResource: "profile_personal", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode(ProfilePersonalEntity.self, from: data) else {
            fatalError()
        }
        return ProfilePersonalResponse(result: result)
    }

    private func getProfileAnnoucementResponse() -> ProfileAnnoucementResponse {
        guard let path = Bundle.main.path(forResource: "profile_announcement", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ProfileAnnoucementEntity].self, from: data) else {
            fatalError()
        }
        return ProfileAnnoucementResponse(result: result)
    }

    private func getProfileCommentResponse() -> ProfileCommentResponse {
        guard let path = Bundle.main.path(forResource: "profile_comment", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ProfileCommentEntity].self, from: data) else {
            fatalError()
        }
        return ProfileCommentResponse(result: result)
    }

    private func getProfileRecentFavoriteResponse() -> ProfileRecentFavoriteResponse {
        guard let path = Bundle.main.path(forResource: "profile_recent_favorite", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ProfileRecentFavoriteEntity].self, from: data) else {
            fatalError()
        }
        return ProfileRecentFavoriteResponse(result: result)
    }
}

// MARK: - Factory

struct ProfileRepositoryFactory {
    static func create() -> ProfileRepository {
        return ProfileRepositoryImpl()
    }
}

struct MockProfileRepositoryFactory {
    static func create() -> ProfileRepository {
        return MockSuccessProfileRepositoryImpl()
    }
}
