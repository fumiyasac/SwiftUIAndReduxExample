//
//  ConnectionErrorView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/24.
//

import SwiftUI

struct ConnectionErrorView: View {

    // MARK: - Typealias

    typealias TapButtonAction = () -> Void

    // MARK: - Property

    private var connectionErrorTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 18)
    }

    private var connectionErrorTitleColor: Color {
        return Color.primary
    }

    private var connectionErrorDescriptionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var connectionErrorDescriptionColor: Color {
        return Color.secondary
    }

    private var connectionErrorButtonFont: Font {
        return Font.custom("AvenirNext-Bold", size: 16)
    }

    private var connectionErrorButtonColor: Color {
        return Color(uiColor: AppConstants.ColorPalette.mint)
    }

    private var tapButtonAction: ProfileSpecialContentsView.TapButtonAction

    // MARK: - Initializer

    init(tapButtonAction: @escaping ConnectionErrorView.TapButtonAction) {
        self.tapButtonAction = tapButtonAction
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0.0) {
            Text("エラー: 画面表示に失敗しました")

                .font(connectionErrorTitleFont)
                .foregroundColor(connectionErrorTitleColor)
                .padding([.bottom], 16.0)
            HStack {
                Text("ネットワークの接続エラー等の要因でデータを取得することができなかった可能性があります。通信の良い環境等で再度のリクエスト実行をお試し下さい。またそれでも解決しない場合には、運営へのお問い合わせをお手数ですが宜しくお願い致します。")
                    .font(connectionErrorDescriptionFont)
                    .foregroundColor(connectionErrorDescriptionColor)
                    .multilineTextAlignment(.leading)
            }
            HStack {
                Spacer()
                Button(action: tapButtonAction, label: {
                    // MEMO: 縁取りをした角丸ボタンのための装飾
                    Text("再度リクエストを実行する")
                        .font(connectionErrorButtonFont)
                        .foregroundColor(connectionErrorButtonColor)
                        .background(.white)
                        .frame(width: 240.0, height: 48.0)
                        .cornerRadius(24.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24.0)
                                .stroke(connectionErrorButtonColor, lineWidth: 1.0)
                        )
                })
                Spacer()
            }
            .padding([.top, .bottom], 24.0)
        }
        .padding([.leading, .trailing], 12.0)
    }
}

struct ConnectionErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionErrorView(tapButtonAction: {})
    }
}
