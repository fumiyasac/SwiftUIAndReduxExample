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

    typealias SocialMediaColorSet = (name: String, color: Color)

    private let socialMediaTitleAndColors: [SocialMediaColorSet] = [
        (name: "Twitter", color: Color(uiColor: UIColor(code: "#00aced"))),
        (name: "Facebook", color: Color(uiColor: UIColor(code: "#3b5998"))),
        (name: "Instagram", color: Color(uiColor: UIColor(code: "#dd2a7b")))
    ]

    // MARK: - Initializer

    init() {}

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            // TODO: 変数socialMediaTitleAndColorsとModelデータより取得した値を合わせて表示する
            ForEach(0..<socialMediaTitleAndColors.count, id: \.self) { index in
                HStack {
                    Text(socialMediaTitleAndColors[index].name)
                        .font(socialMediaTitleFont)
                        .foregroundColor(socialMediaTitleAndColors[index].color)
                    Spacer()
                    Link("URLを開く", destination: URL(string: "https://twitter.com/fumiyasac")!)
                        .font(socialMediaLinkFont)
                        .foregroundColor(socialMediaLinkColor)
                    Image(systemName: "arrow.up.right.square")
                        .font(socialMediaLinkFont)
                        .foregroundColor(socialMediaLinkColor)
                    
                }
                .padding([.leading, .trailing], 4.0)
                .padding([.top, .bottom], 10.0)
            }
        }
        .padding([.leading, .trailing], 12.0)
    }
}

// MARK: - Preview

struct ProfileSocialMediaLinkView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSocialMediaLinkView()
    }
}
