//
//  ProfileInformationCommentView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/02.
//

import SwiftUI

struct ProfileInformationCommentView: View {

    // MARK: - Property

    private var profileCommentViewObjects: [ProfileCommentViewObject]

    // MARK: - Initializer

    init(profileCommentViewObjects: [ProfileCommentViewObject]) {
        self.profileCommentViewObjects = profileCommentViewObjects
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(profileCommentViewObjects) { viewObject in
                ProfileInformationCommentCellView(viewObject: viewObject)
            }
        }
    }
}

// MARK: - ProfileInformationCommentCellView

struct ProfileInformationCommentCellView: View {

    // MARK: - Property

    private var cellTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 13)
    }

    private var cellTitleColor: Color {
        return Color.primary
    }

    private var cellEmotionFont: Font {
        return Font.custom("AvenirNext-Bold", size: 11)
    }

    private var cellEmotionColor: Color {
        return Color.gray
    }

    private var cellDateFont: Font {
        return Font.custom("AvenirNext-Bold", size: 11)
    }

    private var cellDateColor: Color {
        return Color.gray
    }

    private var cellCommentFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var cellCommentColor: Color {
        return Color.secondary
    }

    private var cellBorderColor: Color {
        return Color(uiColor: .lightGray)
    }

    private var viewObject: ProfileCommentViewObject

    // MARK: - Initializer

    init(viewObject: ProfileCommentViewObject) {
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
            Text(viewObject.emotion)
                .font(cellEmotionFont)
                .foregroundColor(cellEmotionColor)
                .lineLimit(1)
                .padding([.top], -8.0)
            Text("公開日: \(viewObject.publishedAt)")
                .font(cellDateFont)
                .foregroundColor(cellDateColor)
                .lineLimit(1)
                .padding([.top], -8.0)
            HStack {
                Text(viewObject.comment)
                    .lineLimit(2)
                    .font(cellCommentFont)
                    .foregroundColor(cellCommentColor)
                    .padding([.top], 2.0)
            }
            Divider()
                .background(cellBorderColor)
        }
    }
}

// MARK: - Preview

struct ProfileInformationCommentView_Previews: PreviewProvider {
    static var previews: some View {
        // MEMO: Section要素全体を表示するためのViewObject
        let profileCommentViewObjects = getProfileCommentResponse().result.map {
            ProfileCommentViewObject(
                id: $0.id,
                emotion: $0.emotion,
                title: $0.title,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt),
                comment: $0.comment
            )
        }
        // Preview: ProfileInformationCommentView
        ProfileInformationCommentView(profileCommentViewObjects: profileCommentViewObjects)
            .previewDisplayName("ProfileInformationCommentView Preview")

        // MEMO: 部品1つあたりを表示するためのViewObject
        let viewObject = ProfileCommentViewObject(
            id: 1,
            emotion: "📝お知らせ",
            title: "年末年始の営業とTake Outについて",
            publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: "2022-12-25T07:30:00.000+0000"),
            comment: "誠に勝手ながら店舗営業につきましては、年末年始期間は2022.12.27〜2023.01.05までとなりますが、お料理のTake Outにつきましては、年末:2022.12.29まで・年始:2023.01.03から開始致しますのでお間違えのない様にお願い致します。"
        )
        // Preview: ProfileInformationCommentCellView
        ProfileInformationCommentCellView(viewObject: viewObject)
            .previewDisplayName("ProfileInformationAnnouncementCellView Preview")
    }

    // MARK: - Private Static Function

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
}
