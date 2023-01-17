//
//  APIClientManager.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/20.
//

import Foundation

// MEMO: APIリクエストに関するEnum定義
enum HTTPMethod {
    case GET
    case POST
}

// MEMO: APIエラーメッセージに関するEnum定義
enum APIError: Error {
    case error(message: String)
}

// MEMO: APIリクエストの状態に関するEnum定義
enum APIRequestState {
    case none
    case requesting
    case success
    case error
}

// MARK: - Protocol

protocol APIClientManagerProtocol {
    
    // MEMO: APIClientManagerはasync/awaitを利用して書く
    func getCampaignBanners() async throws -> CampaignBannersResponse
    func getRecentNews() async throws -> RecentNewsResponse
    func getFeaturedTopics() async throws -> FeaturedTopicsResponse
    func getTrendArticles() async throws -> TrendArticleResponse
    func getPickupPhotos() async throws -> PickupPhotoResponse
    func getFavoriteScenes() async throws -> FavoriteSceneResponse
    func getAchiveImages(keyword: String, category: String) async throws -> ArchiveSceneResponse
}

final class ApiClientManager {

    // MARK: - Singleton Instance

    static let shared = ApiClientManager()

    private init() {}

    // MARK: - Enum

    private enum EndPoint: String {
        // MEMO: Home画面用
        case campaignBanners = "campaign_banners"
        case recentNews = "recent_news"
        case featuredTopics = "featured_topics"
        case trendArticles = "trend_articles"
        case pickupPhotos = "pickup_photos"
        case favoriteScenes = "favorite_scenes"
        case achiveImages = "achive_images"

        func getBaseUrl() -> String {
            return [host, self.rawValue].joined(separator: "/")
        }
    }

    // MARK: - Properties

    // MEMO: API ServerへのURLに関する情報
    private static let host = "http://localhost:3000"

    // MARK: - Function

    func executeAPIRequest<T: Decodable>(endpointUrl: String, withParameters: [String : Any] = [:], httpMethod: HTTPMethod = .GET, responseFormat: T.Type) async throws -> T {

        // MEMO: API通信用のリクエスト作成する（※現状はGET/POSTのみの機構を準備）
        var urlRequest: URLRequest
        switch httpMethod {
        case .GET:
            urlRequest = makeGetRequest(endpointUrl)
        case .POST:
            urlRequest = makePostRequest(endpointUrl, withParameters: withParameters)
        }
        return try await handleAPIRequest(responseType: T.self, urlRequest: urlRequest)
    }

    // MARK: - Private Function

    private func handleAPIRequest<T: Decodable>(responseType: T.Type, urlRequest: URLRequest) async throws -> T {

        // Step1: API Mock Serverへのリクエストを実行する
        let (data, response) = try await executeUrlSession(urlRequest: urlRequest)
        // Step2: 受け取ったResponseを元にハンドリングする
        let _ = try handleErrorByStatusCode(urlRequest: urlRequest, response: response)
        // Step3: JSONをEntityへMappingする
        return try decodeDataToJson(data: data)
    }

    // URLSessionを利用してAPIリクエスト処理を実行する
    // MEMO: URLSession.shared.data(for: urlRequest)はiOS15から利用可能なメソッドである点に注意
    private func executeUrlSession(urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw APIError.error(message: "No network connection.")
        }
    }

    // レスポンスで受け取ったStatusCodeを元にエラーか否かをハンドリングする
    private func handleErrorByStatusCode(urlRequest: URLRequest, response: URLResponse) throws {
        let urlString = String(describing: urlRequest.url?.absoluteString)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.error(message: "No http response (\(urlString)).")
        }
        switch httpResponse.statusCode {
        case 200...399:
            break
        case 400:
            throw APIError.error(message: "Bad Request (\(urlString)).")
        case 401:
            throw APIError.error(message: "Unauthorized (\(urlString)).")
        case 403:
            throw APIError.error(message: "Forbidden (\(urlString)).")
        case 404:
            throw APIError.error(message: "Not Found (\(urlString)).")
        default:
            throw APIError.error(message: "Unknown (\(urlString)).")
        }
    }

    // レスポンスで受け取ったData(JSON)をDecodeしてEntityに変換する
    private func decodeDataToJson<T: Decodable>(data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.error(message: "Failed decode data.")
        }
    }

    // GETリクエストを作成する
    private func makeGetRequest(_ urlString: String) -> URLRequest {

        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL strings.")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // MEMO: 本来であれば認可用アクセストークンをセットする
        let authraizationHeader = ""
        urlRequest.addValue(authraizationHeader , forHTTPHeaderField: "Authorization")
        return urlRequest
    }

    // POSTリクエストを作成する
    private func makePostRequest(_ urlString: String, withParameters: [String : Any] = [:]) -> URLRequest {

        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL strings.")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        // MEMO: Dictionaryで取得したリクエストパラメータをJSONに変換する
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: withParameters, options: [])
            urlRequest.httpBody = requestBody
        } catch {
            fatalError("Invalid request body parameters.")
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // MEMO: 本来であれば認可用アクセストークンをセットする
        let authraizationHeader = ""
        urlRequest.addValue(authraizationHeader , forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

// MARK: - ApiClientManagerProtocol

extension ApiClientManager: APIClientManagerProtocol {
    
    func getCampaignBanners() async throws -> CampaignBannersResponse {
        let result = try await executeAPIRequest(
            endpointUrl: EndPoint.campaignBanners.getBaseUrl(),
            httpMethod: HTTPMethod.GET,
            responseFormat: [CampaignBannerEntity].self
        )
        return CampaignBannersResponse(result: result)
    }
    
    func getRecentNews() async throws -> RecentNewsResponse {
        let result = try await executeAPIRequest(
            endpointUrl: EndPoint.recentNews.getBaseUrl(),
            httpMethod: HTTPMethod.GET,
            responseFormat: [RecentNewsEntity].self
        )
        return RecentNewsResponse(result: result)
    }
    
    func getFeaturedTopics() async throws -> FeaturedTopicsResponse {
        let result = try await executeAPIRequest(
            endpointUrl: EndPoint.featuredTopics.getBaseUrl(),
            httpMethod: HTTPMethod.GET,
            responseFormat: [FeaturedTopicEntity].self
        )
        return FeaturedTopicsResponse(result: result)
    }
    
    func getTrendArticles() async throws -> TrendArticleResponse {
        let result = try await executeAPIRequest(
            endpointUrl: EndPoint.trendArticles.getBaseUrl(),
            httpMethod: HTTPMethod.GET,
            responseFormat: [TrendArticleEntity].self
        )
        return TrendArticleResponse(result: result)
    }

    func getPickupPhotos() async throws -> PickupPhotoResponse {
        let result = try await executeAPIRequest(
            endpointUrl: EndPoint.pickupPhotos.getBaseUrl(),
            httpMethod: HTTPMethod.GET,
            responseFormat: [PickupPhotoEntity].self
        )
        return PickupPhotoResponse(result: result)
    }

    func getFavoriteScenes() async throws -> FavoriteSceneResponse {
        let result = try await executeAPIRequest(
            endpointUrl: EndPoint.favoriteScenes.getBaseUrl(),
            httpMethod: HTTPMethod.GET,
            responseFormat: [FavoriteSceneEntity].self
        )
        return FavoriteSceneResponse(result: result)
    }

    func getAchiveImages(keyword: String, category: String) async throws -> ArchiveSceneResponse {
        let result = try await executeAPIRequest(
            endpointUrl: EndPoint.achiveImages.getBaseUrl(),
            // MEMO: json-serverで作成したAPI側のパラメーターと合わせる
            withParameters: ["q": keyword, "category": category],
            httpMethod: HTTPMethod.GET,
            responseFormat: [ArchiveSceneEntity].self
        )
        return ArchiveSceneResponse(result: result)
    }
}
