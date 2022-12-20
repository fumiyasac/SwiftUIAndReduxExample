//
//  FavoriteCommonSectionView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/14.
//

import SwiftUI

struct FavoriteCommonSectionView: View {

    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var headerWidth: CGFloat {
        return screen.width
    }

    private var headerHeight: CGFloat {
        return 86.0
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

    // MARK: - Initializer

    init() {}

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("編集部が選ぶお気に入りのグルメ")
                    .font(sectionTitleFont)
                    .foregroundColor(sectionTitleColor)
                    .lineLimit(1)
                Text("Favorite Gourmet Selected by The Editorial Department.")
                    .font(sectionSubtitleFont)
                    .foregroundColor(sectionSubtitleColor)
                    .lineLimit(1)
                Text("👉スワイプすると続きを見る事ができます。")
                    .font(sectionSubtitleFont)
                    .foregroundColor(sectionSubtitleColor)
                    .lineLimit(1)
                    .padding([.top], -8.0)
            }
            Spacer()
        }
        .padding(12.0)
        .frame(width: headerWidth)
        .frame(height: headerHeight)
    }
}

// MARK: - Preview

struct FavoriteCommonSectionView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteCommonSectionView()
    }
}
