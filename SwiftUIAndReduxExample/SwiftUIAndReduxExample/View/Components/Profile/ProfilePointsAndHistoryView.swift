//
//  ProfilePointsAndHistoryView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/31.
//

import SwiftUI

struct ProfilePointsAndHistoryView: View {

    // MARK: - Property

    private var pointAndHistoryTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 12)
    }

    private var pointAndHistoryValueFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var pointAndHistoryTitleColor: Color {
        return Color.secondary
    }

    private var pointAndHistoryValueColor: Color {
        return Color.gray
    }

    private let pointAndHistoryTitles: [String] = [
        "😁 Profile訪問数:",
        "📝 記事投稿数:",
        "✨ 総合PV数:",
        "💰 獲得ポイント:",
        "🎫 クーポン利用回数:",
        "🍔 お店に行った回数:"
    ]

    // MARK: - Initializer

    init() {}

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0.0) {
            // 上側Divider
            Divider()
                .background(.gray)

            // TODO: 変数pointAndHistoryTitlesとModelデータより取得した値を合わせて表示する
            ForEach(0..<pointAndHistoryTitles.count, id: \.self) { index in
                // 1. 数値及びポイント表示部分
                HStack {
                    // 1-(1). タイトル表示
                    Text("\(pointAndHistoryTitles[index])")
                        .font(pointAndHistoryTitleFont)
                        .foregroundColor(pointAndHistoryTitleColor)
                        .padding(8.0)
                        .lineLimit(1)
                        .font(Font.system(.body).bold())
                    // 1-(2). Spacer
                    Spacer(minLength: 16.0)
                    // 1-(3). データ表示
                    Text("0")
                        .font(pointAndHistoryValueFont)
                        .foregroundColor(pointAndHistoryValueColor)
                        .padding(8.0)
                        .frame(alignment: .trailing)
                }
                .frame(height: 48.0)
                // 2. 下側Divider
                Divider()
                    .background(.gray)
            }
        }
        .padding([.leading, .trailing], 8.0)
    }
}

// MARK: - Preview

struct ProfilePointsAndHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePointsAndHistoryView()
    }
}
