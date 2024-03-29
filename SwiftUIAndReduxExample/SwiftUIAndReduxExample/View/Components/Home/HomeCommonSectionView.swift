//
//  HomeCommonSectionView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/07.
//

import SwiftUI

struct HomeCommonSectionView: View {

    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var headerWidth: CGFloat {
        return screen.width
    }

    private var sectionTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 18)
    }

    private var sectionSubtitleFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var sectionTitleColor: Color {
        return Color.primary
    }

    private var sectionSubtitleColor: Color {
        return Color.secondary
    }

    @State private var titleTextSet: (title: String, subTitle: String)

    // MARK: - Initializer

    init(title: String, subTitle: String) {
        _titleTextSet = State(initialValue: (title: title, subTitle: subTitle))
    }

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(titleTextSet.title)
                    .font(sectionTitleFont)
                    .foregroundColor(sectionTitleColor)
                    .lineLimit(1)
                Text(titleTextSet.subTitle)
                    .font(sectionSubtitleFont)
                    .foregroundColor(sectionSubtitleColor)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(12.0)
        .frame(width: headerWidth)
    }
}

// MARK: - Preview

#Preview("季節の特集コンテンツ一覧") {
    HomeCommonSectionView(title: "季節の特集コンテンツ一覧", subTitle: "Introduce seasonal shopping and features.")
}

#Preview("最新のおしらせ") {
    HomeCommonSectionView(title: "最新のおしらせ", subTitle: "Let's Check Here for App-only Notifications.")
}

#Preview("特集掲載店舗") {
    HomeCommonSectionView(title: "特集掲載店舗", subTitle: "Please Teach Us Your Favorite Gourmet.")
}

#Preview("トレンド記事紹介") {
    HomeCommonSectionView(title: "トレンド記事紹介", subTitle: "Memorial Articles about Special Season.")
}

#Preview("ピックアップ写真集") {
    HomeCommonSectionView(title: "ピックアップ写真集", subTitle: "Let's Enjoy Pickup Gourmet Photo Archives.")
}
