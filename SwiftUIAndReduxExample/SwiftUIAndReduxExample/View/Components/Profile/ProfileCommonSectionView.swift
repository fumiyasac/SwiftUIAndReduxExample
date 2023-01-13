//
//  ProfileCommonSectionView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/30.
//

import SwiftUI

struct ProfileCommonSectionView: View {

    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var headerWidth: CGFloat {
        return screen.width
    }

    private var headerHeight: CGFloat {
        return 68.0
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
        .frame(width: headerWidth, height: headerHeight)
    }
}

// MARK: - Preview

struct ProfileCommonSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCommonSectionView(
            title: "自己紹介文",
            subTitle: "Self Inftoduction"
        )
    }
}
