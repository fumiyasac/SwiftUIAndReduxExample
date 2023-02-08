//
//  ProfileSpecialContentsView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/01.
//

import SwiftUI

struct ProfileSpecialContentsView: View {

    // MARK: - Typealias

    typealias TapButtonAction = () -> Void

    // MARK: - Property

    private var specialContentsDescriptionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var specialContentsDescriptionColor: Color {
        return Color.secondary
    }

    private var specialContentsButtonFont: Font {
        return Font.custom("AvenirNext-Bold", size: 16)
    }

    private var specialContentsButtonColor: Color {
        return Color(uiColor: UIColor(code: "#b9d9c3"))
    }

    private var tapButtonAction: ProfileSpecialContentsView.TapButtonAction

    // MARK: - Initializer

    init(tapButtonAction: @escaping ProfileSpecialContentsView.TapButtonAction) {
        self.tapButtonAction = tapButtonAction
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HStack {
                Text("これまで書いた店舗のご紹介記事や行ったお店、さらには投稿した写真等を元にしたデータ分析結果から当アプリがレコメンドする情報をお届けしております。気になったお店のクーポンやメニューを見つけて、素敵なお店やお食事と出会う機会を是非増やしてみてください！")
                    .font(specialContentsDescriptionFont)
                    .foregroundColor(specialContentsDescriptionColor)
            }
            HStack {
                Spacer()
                Button(action: tapButtonAction, label: {
                    // MEMO: 縁取りをした角丸ボタンのための装飾
                    Text("特集コンテンツを確認する")
                        .font(specialContentsButtonFont)
                        .foregroundColor(specialContentsButtonColor)
                        .background(.white)
                        .frame(width: 240.0, height: 48.0)
                        .cornerRadius(24.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24.0)
                                .stroke(specialContentsButtonColor, lineWidth: 1.0)
                        )
                })
                Spacer()
            }
            .padding([.top, .bottom], 24.0)
        }
        .padding([.leading, .trailing], 12.0)
    }
}

// MARK: - Preview

struct ProfileSpecialContentsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSpecialContentsView(tapButtonAction: {})
    }
}
