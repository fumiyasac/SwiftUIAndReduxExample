//
//  CampaignBannersRepository.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/18.
//

import Foundation

// MARK: - Protocol

protocol CampaignBannersRepository {
    func getHomeResponses() async throws -> CampaignBannersResponse
}

final class CampaignBannersRepositoryImpl: CampaignBannersRepository {
    func getHomeResponses() async throws -> CampaignBannersResponse {
        return try await ApiClientManager.shared.getCampaignBanners()
    }
}

final class CampaignBannersRepositoryFactory {
    static func create() -> CampaignBannersRepository {
        return CampaignBannersRepositoryImpl()
    }
}

// TODO: Mock用のデータを作るためのFactory
//struct CampaignBannersRepositoryMockFactory {
//    static func createXXX() -> HomeRepository {
//        return HomeRepositoryImpl()
//    }
//}
