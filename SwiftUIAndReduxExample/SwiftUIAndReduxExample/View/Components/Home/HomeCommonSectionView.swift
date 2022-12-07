//
//  HomeCommonSectionView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/07.
//

import SwiftUI

struct HomeCommonSectionView: View {

    // MARK: - Property

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
            VStack {
                Text(titleTextSet.title)
                    .font(sectionTitleFont)
                    .foregroundColor(sectionTitleColor)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(titleTextSet.subTitle)
                    .font(sectionSubtitleFont)
                    .foregroundColor(sectionSubtitleColor)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12.0)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}

struct HomeCommonSectionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HomeCommonSectionView(title: "季節の特集コンテンツ一覧", subTitle: "Introduce seasonal shopping and features.")
            HomeCommonSectionView(title: "ピックアップ写真集", subTitle: "Let's Enjoy Pickup Gourmet Photo Archives.")
        }
    }
}
