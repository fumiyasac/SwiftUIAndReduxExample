//
//  ProfileInformationAnnouncementView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/02.
//

import SwiftUI

struct ProfileInformationAnnouncementView: View {

    // MARK: - Property

    private let profileAnnoucementViewObjects: [ProfileAnnoucementViewObject]

    // MARK: - Initializer

    init(profileAnnoucementViewObjects: [ProfileAnnoucementViewObject]) {
        self.profileAnnoucementViewObjects = profileAnnoucementViewObjects
    }
    
    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(profileAnnoucementViewObjects) { viewObject in
                ProfileInformationAnnouncementCellView(viewObject: viewObject)
            }
        }
    }
}

// MARK: - ProfileInformationAnnouncementCellView

struct ProfileInformationAnnouncementCellView: View {

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

    private let viewObject: ProfileAnnoucementViewObject

    // MARK: - Initializer

    init(viewObject: ProfileAnnoucementViewObject) {
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

#Preview("ProfileInformationAnnouncementView Preview") {
    // MEMO: Section要素全体を表示するためのViewObject
    let profileAnnoucementViewObjects = getProfileAnnoucementResponse().result.map {
        ProfileAnnoucementViewObject(
            id: $0.id,
            category: $0.category,
            title: $0.title,
            publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt),
            description: $0.description
        )
    }
    // Preview: ProfileInformationAnnouncementView
    return ProfileInformationAnnouncementView(profileAnnoucementViewObjects: profileAnnoucementViewObjects)

    // MARK: - Function

    func getProfileAnnoucementResponse() -> ProfileAnnoucementResponse {
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
}

#Preview("ProfileInformationAnnouncementCellView Preview") {
    // MEMO: 部品1つあたりを表示するためのViewObject
    let viewObject = ProfileAnnoucementViewObject(
        id: 1,
        category: "公式情報",
        title: "クリスマスシーズンキャンペーンの結果報告",
        publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: "2022-12-25T07:30:00.000+0000"),
        description: "2022.12.01〜2022.12.25に開催されたクリスマスシーズンキャンペーンの結果を公開しております。今後の記事執筆やキャンペーン参加をご検討されているユーザー様はご一読頂けますと嬉しく思います。"
    )
    // Preview: ProfileInformationAnnouncementCellView
    return ProfileInformationAnnouncementCellView(viewObject: viewObject)
}
