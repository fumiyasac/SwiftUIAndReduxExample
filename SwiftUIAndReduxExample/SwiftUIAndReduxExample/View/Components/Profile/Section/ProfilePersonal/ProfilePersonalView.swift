//
//  ProfilePersonalView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/30.
//

import SwiftUI
import Kingfisher

struct ProfilePersonalView: View {

    // MARK: - Property

    private var personNameFont: Font {
        return Font.custom("AvenirNext-Bold", size: 14)
    }

    private var personNameColor: Color {
        return Color.primary
    }

    private var personRegistrationFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var personRegistrationColor: Color {
        return Color.gray
    }

    private var personIdFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var personIdColor: Color {
        return Color.gray
    }

    private var viewHeight: CGFloat {
        return 86.0
    }

    private var profilePersonalViewObject: ProfilePersonalViewObject

    // MARK: - Initializer

    init(profilePersonalViewObject: ProfilePersonalViewObject) {
        self.profilePersonalViewObject = profilePersonalViewObject
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HStack {
                // 1. プロフィール用アバター表示
                KFImage(profilePersonalViewObject.avatarUrl)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 58.0, height: 58.0)
                    .shadow(radius: 4.0)
                // 2. プロフィール用基本情報表示
                VStack(alignment: .leading) {
                    // 2-(1). ユーザー名表示
                    Text(profilePersonalViewObject.nickname)
                        .font(personNameFont)
                        .foregroundColor(personNameColor)
                    // 2-(2). ユーザー登録日表示
                    Text(profilePersonalViewObject.createdAt)
                        .font(personRegistrationFont)
                        .foregroundColor(personRegistrationColor)
                        .padding([.top], -8.0)
                    // 2-(3). ユーザー最終ログイン日時表示
                    Text("ユーザーID: \(profilePersonalViewObject.id)")
                        .font(personIdFont)
                        .foregroundColor(personIdColor)
                        .padding([.top], -8.0)
                }
                .padding([.leading], 8.0)
                Spacer()
            }
        }
        .padding([.leading, .trailing], 12.0)
        .frame(height: viewHeight)
    }
}

// MARK: - Preview

struct ProfilePersonalView_Previews: PreviewProvider {
    static var previews: some View {
        // MEMO: 部品1つあたりを表示するためのViewObject
        let profilePersonalViewObject = ProfilePersonalViewObject(
            id: 100,
            nickname: "謎多き料理人",
            createdAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: "2022-11-16T07:30:00.000+0000"),
            avatarUrl: URL(string: "https://ones-mind-topics.s3.ap-northeast-1.amazonaws.com/profile_avatar_sample.jpg")
        )
        // Preview: ProfilePersonalView
        ProfilePersonalView(profilePersonalViewObject: profilePersonalViewObject)
    }
}
