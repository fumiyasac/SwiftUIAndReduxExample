//
//  ProfileContentsView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/26.
//

import SwiftUI

struct ProfileContentsView: View {

    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var contentsWidth: CGFloat {
        return screen.width
    }

    private var parallaxHeaderHeight: CGFloat {
        return contentsWidth * 2 / 3
    }

    private var cellThumbnailMaskColor: Color {
        return Color.black.opacity(0.12)
    }

    // MARK: - Initializer

    init() {}
    
    // MARK: - Body

    var body: some View {
        // View要素のベース部分はScrollViewで構成する
        ScrollView {

            // MEMO: このままだと隙間ができてしまうので、ScrollView直下にVStackを入れてspacingの値を0として調整しています。
            // 参考: https://qiita.com/masa7351/items/3f169b65f38da29fbf76
            VStack(spacing: 0) {

                // 1. GrometryReaderを利用した背景用サムネイル画像Parallax表現部分
                GeometryReader { geometry in
                    // 👉 GeometryReaderで返されるGeometryProxyの値を元にして
                    getBackgroundViewBy(geometry: geometry)
                }
                .frame(height: parallaxHeaderHeight)
            
                // 2. ユーザーの基本情報を表示部分
                ProfilePersonalView()

                // 3. 自己紹介本文表示部分
                Group {
                    ProfileCommonSectionView(title: "自己紹介文", subTitle: "Self Inftoduction")
                    ProfileSelfIntroductionView()
                }

                // 4. 現在の取得ポイント等の履歴部分
                Group {
                    ProfileCommonSectionView(title: "現在の保有ポイントや履歴", subTitle: "Self Points & Histories")
                }
            }
            
            


            

            
            // 5. SocialMedia等のリンク表示部分
            
            // 6. パーソナル向け情報タブ表示部分
            
            // 7. スペシャルコンテンツ表示部分
            
        }
    }

    // MARK: - Private Function

    // スクロールに追従したHeader画像部分のParallax表示(Stretchy Header)部分のView要素
    // 参考: https://gist.github.com/beliy/f46a34b03827b2a8238b6daa2a356bef
    // @ViewBuilderを利用してViewを出し分けています
    // 参考: https://yanamura.hatenablog.com/entry/2019/09/05/150849
    @ViewBuilder
    private func getBackgroundViewBy(geometry: GeometryProxy) -> some View {
        if geometry.frame(in: .global).minY <= 0 {
            // (1) ScrollViewにおいて一番上にある状態から更に下方向へスクロールした場合
            // 👉 Header用のサムネイル画像が拡大される様な形の表現をするための処理
            ZStack {
                Image("profile_header_sample")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                Rectangle()
                    .foregroundColor(cellThumbnailMaskColor)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            
        } else {
            // (2) 上方向へスクロールした場合
            // 👉 画像の比率を維持してピッタリと画面にはまる大きさを保持した状態でスクロールに追従させるための処理
            ZStack {
                Image("profile_header_sample")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                Rectangle()
                    .foregroundColor(cellThumbnailMaskColor)
            }
            .offset(y: -geometry.frame(in: .global).minY)
            .frame(
                width: geometry.size.width,
                height: geometry.size.height + geometry.frame(in: .global).minY
            )
        }

    }
}

// MARK: - Preview

struct ProfileContentsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileContentsView()
    }
}
