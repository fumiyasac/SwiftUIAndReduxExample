//
//  ProfileInformationView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/01.
//

import SwiftUI

struct ProfileInformationView: View {

    // MARK: - Property

    private var personalInformationDescriptionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var personalInformationDescriptionColor: Color {
        return Color.secondary
    }

    private var profileInformationViewObject: ProfileInformationViewObject

    // MARK: - Initializer

    init(profileInformationViewObject: ProfileInformationViewObject) {
        self.profileInformationViewObject = profileInformationViewObject
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            // 1. 概要文テキスト表示
            HStack {
                Text("気になっている店舗からの最新情報やあなた宛のコメント等を表示しています。定期的に更新されるので是非ともお見逃しなく確認してみて下さいね！")
                    .font(personalInformationDescriptionFont)
                    .foregroundColor(personalInformationDescriptionColor)
            }
            .padding([.bottom], 16.0)
            // 2. タブ型コンテンツ表示
            // 👉 Tab表示と要素表示を管理しているProfileInformationTabSwitcherにイニシャライザから取得したViewObjectを引き渡す
            ProfileInformationTabSwitcher(profileInformationViewObject: profileInformationViewObject)
                .padding([.bottom], 8.0)
        }
        .padding([.leading, .trailing], 12.0)
    }
}

// MARK: - Preview

struct ProfileInformationView_Previews: PreviewProvider {
    static var previews: some View {
        // MEMO: 部品1つあたりを表示するためのViewObject
        let profileAnnoucementViewObjects = getProfileAnnoucementResponse().result.map {
            ProfileAnnoucementViewObject(
                id: $0.id,
                category: $0.category,
                title: $0.title,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt),
                description: $0.description
            )
        }
        let profileCommentViewObjects = getProfileCommentResponse().result.map {
            ProfileCommentViewObject(
                id: $0.id,
                emotion: $0.emotion,
                title: $0.title,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt),
                comment: $0.comment
            )
        }
        let profileRecentFavoriteViewObjects = getProfileRecentFavoriteResponse().result.map {
            ProfileRecentFavoriteViewObject(
                id: $0.id,
                category: $0.category,
                title: $0.title,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt),
                description: $0.description
            )
        }
        let profileInformationViewObject = ProfileInformationViewObject(
            id: 100,
            profileAnnoucementViewObjects: profileAnnoucementViewObjects,
            profileCommentViewObjects: profileCommentViewObjects,
            profileRecentFavoriteViewObjects: profileRecentFavoriteViewObjects
        )
        // Preview: ProfileInformationView
        ProfileInformationView(profileInformationViewObject: profileInformationViewObject)
    }

    // MARK: - Private Static Function

    private static func getProfileAnnoucementResponse() -> ProfileAnnoucementResponse {
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

    private static func getProfileCommentResponse() -> ProfileCommentResponse {
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

    private static func getProfileRecentFavoriteResponse() -> ProfileRecentFavoriteResponse {
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
