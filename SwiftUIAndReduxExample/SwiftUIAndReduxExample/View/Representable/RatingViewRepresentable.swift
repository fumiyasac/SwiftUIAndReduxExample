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

    @Binding var rating: Double
    
    // MARK: - Function

    func makeUIView(context: Context) -> CosmosView {
        CosmosView()
    }

    func updateUIView(_ uiView: CosmosView, context: Context) {

        // @BindingでRatingの数値を反映する
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
        uiView.settings.starSize = 40
    }
}

//struct RatingView_Previews: PreviewProvider {
//    static var previews: some View {
//        RatingView()
//    }
//}
