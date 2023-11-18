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

    private var pointAndHistoryBorderColor: Color {
        return Color(uiColor: .lightGray)
    }

    private let profilePointsAndHistoryViewObject: ProfilePointsAndHistoryViewObject

    // MEMO: LazyVGridに表示する内容を格納するための変数
    @State private var pointAndHistoryPairs: [PointAndHistoryPair] = []

    // MARK: - Typealias

    typealias PointAndHistoryPair = (title: String, score: Int)

    // MARK: - Initializer

    init(profilePointsAndHistoryViewObject: ProfilePointsAndHistoryViewObject) {
        self.profilePointsAndHistoryViewObject = profilePointsAndHistoryViewObject

        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        _pointAndHistoryPairs = State(
            initialValue: [
                PointAndHistoryPair(title: "😁 Profile訪問数:", score: profilePointsAndHistoryViewObject.profileViewCount),
                PointAndHistoryPair(title: "📝 記事投稿数:", score: profilePointsAndHistoryViewObject.articlePostCount),
                PointAndHistoryPair(title: "✨ 総合PV数:", score: profilePointsAndHistoryViewObject.totalPageViewCount),
                PointAndHistoryPair(title: "💰 獲得ポイント:", score: profilePointsAndHistoryViewObject.totalAvailablePoints),
                PointAndHistoryPair(title: "🎫 クーポン利用回数:", score: profilePointsAndHistoryViewObject.totalUseCouponCount),
                PointAndHistoryPair(title: "🍔 お店に行った回数:", score: profilePointsAndHistoryViewObject.totalVisitShopCount)
            ]
        )
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0.0) {
            // 上側Divider
            Divider()
                .background(.gray)
            // 変数pointAndHistoryPairsより取得した値を合わせて表示する
            ForEach(0..<pointAndHistoryPairs.count, id: \.self) { index in
                // 1. 数値及びポイント表示部分
                HStack {
                    // 1-(1). タイトル表示
                    Text(pointAndHistoryPairs[index].title)
                        .font(pointAndHistoryTitleFont)
                        .foregroundColor(pointAndHistoryTitleColor)
                        .padding(8.0)
                        .lineLimit(1)
                    // 1-(2). Spacer
                    Spacer(minLength: 16.0)
                    // 1-(3). データ表示
                    Text("\(pointAndHistoryPairs[index].score)")
                        .font(pointAndHistoryValueFont)
                        .foregroundColor(pointAndHistoryValueColor)
                        .padding(8.0)
                        .frame(alignment: .trailing)
                }
                .frame(height: 48.0)
                // 2. 下側Divider
                Divider()
                    .background(pointAndHistoryBorderColor)
            }
        }
        .padding([.leading, .trailing], 12.0)
    }
}

// MARK: - Preview

#Preview("ProfilePointsAndHistoryView Preview") {
    // MEMO: 部品1つあたりを表示するためのViewObject
    let profilePointsAndHistoryViewObject = ProfilePointsAndHistoryViewObject(
        id: 100,
        profileViewCount: 6083,
        articlePostCount: 37,
        totalPageViewCount: 103570,
        totalAvailablePoints: 4000,
        totalUseCouponCount: 24,
        totalVisitShopCount: 58
    )
    // Preview: ProfilePointsAndHistoryView
    return ProfilePointsAndHistoryView(profilePointsAndHistoryViewObject: profilePointsAndHistoryViewObject)
}
