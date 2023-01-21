//
//  ProfilePersonalEntity.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/21.
//

import Foundation

struct ProfilePersonalEntity: Hashable, Decodable {
    
    let id: Int
    let nickname: String
    let createdAt: String
    let avatarUrl: String
    let backgroundImageUrl: String
    let introduction: String
    let histories: ProfileHistoriesEntity
    let socialMedia: ProfileSocialMediaEntity
    
    // MARK: - Enum
    
    private enum Keys: String, CodingKey {
        case id
        case nickname
        case createdAt = "created_at"
        case avatarUrl = "avatar_url"
        case backgroundImageUrl = "background_image_url"
        case introduction
        case histories
        case socialMedia = "social_media"
    }
    
    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        self.backgroundImageUrl = try container.decode(String.self, forKey: .backgroundImageUrl)
        self.introduction = try container.decode(String.self, forKey: .introduction)
        self.histories = try container.decode(ProfileHistoriesEntity.self, forKey: .histories)
        self.socialMedia = try container.decode(ProfileSocialMediaEntity.self, forKey: .socialMedia)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ProfilePersonalEntity, rhs: ProfilePersonalEntity) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ProfileHistoriesEntity: Decodable {
    
    let profileViewCount: Int
    let articlePostCount: Int
    let totalPageViewCount: Int
    let totalAvailablePoints: Int
    let totalUseCouponCount: Int
    let totalVisitShopCount: Int
    
    // MARK: - Enum
    
    private enum Keys: String, CodingKey {
        case profileViewCount = "profile_view_count"
        case articlePostCount = "article_post_count"
        case totalPageViewCount = "total_page_view_count"
        case totalAvailablePoints = "total_available_points"
        case totalUseCouponCount = "total_use_coupon_count"
        case totalVisitShopCount = "total_visit_shop_count"
    }

    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.profileViewCount = try container.decode(Int.self, forKey: .profileViewCount)
        self.articlePostCount = try container.decode(Int.self, forKey: .articlePostCount)
        self.totalPageViewCount = try container.decode(Int.self, forKey: .totalPageViewCount)
        self.totalAvailablePoints = try container.decode(Int.self, forKey: .totalAvailablePoints)
        self.totalUseCouponCount = try container.decode(Int.self, forKey: .totalUseCouponCount)
        self.totalVisitShopCount = try container.decode(Int.self, forKey: .totalVisitShopCount)
    }
}

struct ProfileSocialMediaEntity: Decodable {
    
    let twitterUrl: String
    let facebookUrl: String
    let instagramUrl: String
    
    // MARK: - Enum
    
    private enum Keys: String, CodingKey {
        case twitterUrl = "twitter_url"
        case facebookUrl = "facebook_url"
        case instagramUrl = "instagram_url"
    }
    
    // MARK: - Initializer

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.twitterUrl = try container.decode(String.self, forKey: .twitterUrl)
        self.facebookUrl = try container.decode(String.self, forKey: .facebookUrl)
        self.instagramUrl = try container.decode(String.self, forKey: .instagramUrl)
    }
}
