//
//  ProfileInformationRecentView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/02.
//

import SwiftUI

struct ProfileInformationRecentView: View {

    // MARK: - Property

    private let profileRecentFavoriteViewObjects: [ProfileRecentFavoriteViewObject]

    // MARK: - Initializer

    init(profileRecentFavoriteViewObjects: [ProfileRecentFavoriteViewObject]) {
        self.profileRecentFavoriteViewObjects = profileRecentFavoriteViewObjects
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(profileRecentFavoriteViewObjects) { viewObject in
                ProfileInformationRecentCellView(viewObject: viewObject)
            }
        }
    }
}

// MARK: - ProfileInformationRecentCellView

struct ProfileInformationRecentCellView: View {

    // MARK: - Property

    private var cellTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 13)
    }

    private var cellTitleColor: Color {
        return Color.primary
    }

    private var cellCategoryFont: Font {
        return Font.custom("AvenirNext-Bold", size: 11)
    }

    private var cellCategoryColor: Color {
        return Color.gray
    }

    private var cellDateFont: Font {
        return Font.custom("AvenirNext-Bold", size: 11)
    }

    private var cellDateColor: Color {
        return Color.gray
    }

    private var cellDescriptionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var cellDescriptionColor: Color {
        return Color.secondary
    }

    private var cellBorderColor: Color {
        return Color(uiColor: .lightGray)
    }

    private var viewObject: ProfileRecentFavoriteViewObject

    // MARK: - Initializer

    init(viewObject: ProfileRecentFavoriteViewObject) {
        self.viewObject = viewObject
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewObject.title)
                .font(cellTitleFont)
                .foregroundColor(cellTitleColor)
                .lineLimit(1)
                .padding([.top], 4.0)
            Text(viewObject.category)
                .font(cellCategoryFont)
                .foregroundColor(cellCategoryColor)
                .lineLimit(1)
                .padding([.top], -8.0)
            Text("公開日: \(viewObject.publishedAt)")
                .font(cellDateFont)
                .foregroundColor(cellDateColor)
                .lineLimit(1)
                .padding([.top], -8.0)
            HStack {
                Text(viewObject.description)
                    .lineLimit(2)
                    .font(cellDescriptionFont)
                    .foregroundColor(cellDescriptionColor)
                    .padding([.top], 2.0)
            }
            Divider()
                .background(cellBorderColor)
        }
    }
}

// MARK: - Preview

struct ProfileInformationRecentView_Previews: PreviewProvider {
    static var previews: some View {
        // MEMO: Section要素全体を表示するためのViewObject
        let profileRecentFavoriteViewObjects = getProfileRecentFavoriteResponse().result.map {
            ProfileRecentFavoriteViewObject(
                id: $0.id,
                category: $0.category,
                title: $0.title,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt),
                description: $0.description
            )
        }
        // Preview: ProfileInformationRecentView
        ProfileInformationRecentView(profileRecentFavoriteViewObjects: profileRecentFavoriteViewObjects)
            .previewDisplayName("ProfileInformationRecentView Preview")

        // MEMO: 部品1つあたりを表示するためのViewObject
        let viewObject = ProfileRecentFavoriteViewObject(
            id: 1,
            category: "新商品のご案内🍣",
            title: "にぎり寿司のランチテイクアウトはじめました✨",
            publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: "2023-01-01T07:30:00.000+0000"),
            description: "おまかせにぎり12貫セットをランチテイクアウトスタイルで1500円にて販売することにしました！ちょっと贅沢なお弁当としてもピッタリですので、是非とも一度お試し下さいませ😊"
        )
        // Preview: ProfileInformationRecentCellView
        ProfileInformationRecentCellView(viewObject: viewObject)
            .previewDisplayName("ProfileInformationRecentCellView Preview")
    }

    // MARK: - Private Static Function

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
