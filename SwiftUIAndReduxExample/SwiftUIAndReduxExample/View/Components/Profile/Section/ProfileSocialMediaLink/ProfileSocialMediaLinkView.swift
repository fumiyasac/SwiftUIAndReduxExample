//
//  ProfileSocialMediaLinkView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/01.
//

import SwiftUI

struct ProfileSocialMediaLinkView: View {
    
    // MARK: - Property

    private var socialMediaTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 14)
    }

    private var socialMediaLinkFont: Font {
        return Font.custom("AvenirNext-Regular", size: 13)
    }

    private var socialMediaLinkColor: Color {
        return Color.secondary
    }

    private let profileSocialMediaViewObject: ProfileSocialMediaViewObject

    // MEMO: LazyVGridに表示する内容を格納するための変数
    @State private var socialMediaSets: [SocialMediaSet] = []

    // MARK: - Typealias

    typealias SocialMediaSet = (name: String, color: Color, url: URL?)

    // MARK: - Initializer

    init(profileSocialMediaViewObject: ProfileSocialMediaViewObject) {
        self.profileSocialMediaViewObject = profileSocialMediaViewObject

        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        _socialMediaSets = State(
            initialValue: [
                SocialMediaSet(name: "Twitter", color: Color(uiColor: UIColor(code: "#00aced")), url: profileSocialMediaViewObject.twitterUrl),
                SocialMediaSet(name: "Facebook", color: Color(uiColor: UIColor(code: "#3b5998")), url: profileSocialMediaViewObject.facebookUrl),
                SocialMediaSet(name: "Instagram", color: Color(uiColor: UIColor(code: "#dd2a7b")), url: profileSocialMediaViewObject.instagramUrl)
            ]
        )
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            // 変数socialMediaSetsより取得した値を合わせて表示する
            ForEach(0..<socialMediaSets.count, id: \.self) { index in
                HStack {
                    Text(socialMediaSets[index].name)
                        .font(socialMediaTitleFont)
                        .foregroundColor(socialMediaSets[index].color)
                    Spacer()
                    if let url = socialMediaSets[index].url {
                        Link("URLを開く", destination: url)
                            .font(socialMediaLinkFont)
                            .foregroundColor(socialMediaLinkColor)
                        Image(systemName: "arrow.up.right.square")
                            .font(socialMediaLinkFont)
                            .foregroundColor(socialMediaLinkColor)
                    } else {
                        Text("No Link")
                            .font(socialMediaLinkFont)
                            .foregroundColor(socialMediaLinkColor)
                    }
                }
                .padding([.leading, .trailing], 4.0)
                .padding([.top, .bottom], 10.0)
            }
        }
        .padding([.leading, .trailing], 12.0)
    }
}

// MARK: - Preview

#Preview {
    // MEMO: 部品1つあたりを表示するためのViewObject
    let profileSocialMediaViewObject = ProfileSocialMediaViewObject(
        id: 100,
        twitterUrl: URL(string: "https://twitter.com/"),
        facebookUrl: URL(string: "https://facebook.com/"),
        instagramUrl: URL(string: "https://instagram.com/")
    )
    return ProfileSocialMediaLinkView(profileSocialMediaViewObject: profileSocialMediaViewObject)
}
