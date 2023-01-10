//
//  RatingViewRepresentable.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/01/09.
//

import SwiftUI
import Cosmos

// MEMO: UIKit製ライブラリ「CosmosView」をSwiftUIで利用する
// https://github.com/evgenyneu/Cosmos/wiki/Using-Cosmos-with-SwiftUI

struct RatingViewRepresentable: UIViewRepresentable {

    // MARK: - Property

    // 👉 親のView要素から受け取ったRatingの値をこの構造体の中で利用していく。
    @Binding var rating: Double
    
    // MARK: - Function

    func makeUIView(context: Context) -> CosmosView {
        return CosmosView()
    }

    func updateUIView(_ uiView: CosmosView, context: Context) {

        // @Bindingで設定されたRatingの数値を反映する
        uiView.rating = rating

        // 内在サイズに則って自動でCosmosViewをリサイズする
        // 参考: 内在サイズについての説明
        // https://developer.mozilla.org/ja/docs/Glossary/Intrinsic_Size
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        // ライブラリ「Cosmos」で調整可能な値を独自に調整する際に利用する
        setupCosmosViewSettings(uiView)
    }

    private func setupCosmosViewSettings(_ uiView: CosmosView) {

        // MEMO: ライブラリ「Cosmos」の基本設定部分
        // 👉 色やサイズをはじめ表示モード等についても細かく設定が可能です。
        uiView.settings.fillMode = .precise
        uiView.settings.starSize = 26
        uiView.settings.emptyBorderWidth = 1.0
        uiView.settings.filledBorderWidth = 1.0
        uiView.settings.emptyBorderColor = .systemYellow
        uiView.settings.filledColor = .systemYellow
        uiView.settings.filledBorderColor = .systemYellow
    }
}
