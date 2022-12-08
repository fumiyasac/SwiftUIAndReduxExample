//
//  RecentNewsCarouselView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/07.
//

import SwiftUI

// MEMO: 中央寄せCarousel方式でのバナー表示の参考
// https://levelup.gitconnected.com/snap-to-item-scrolling-debccdcbb22f

struct RecentNewsCarouselView: View {

    // MARK: - Property

    // TODO: News要素を定義する
    var colors: [Color] = [.blue, .green, .red, .orange]

    private let screen = UIScreen.main.bounds
    private let baseSpacing: CGFloat = 16.0
    private let sectionSpacing: CGFloat = 16.0
    private let sectionHeight: CGFloat = 450.0

    private var sectionWidth: CGFloat {
        return screen.width - sectionSpacing
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: baseSpacing) {
            // TODO: 1Sectionに3要素表示する形のViewを定義する
            ForEach(0..<colors.count) { i in
                 colors[i]
                     .frame(width: sectionWidth, height: sectionHeight, alignment: .leading)
            }
        }
        // MEMO: DragGestureの値変化を利用したCarousel表示用のModifier定義
        // 👉 CampaignBannerCarouselViewとは異なりCarouselにまつわる処理のほとんどをModifierで実行するイメージ
        .modifier(
            RecentNewsCarouselViewModifier(sections: colors.count, sectionWidth: sectionWidth, sectionSpacing: sectionSpacing)
        )
    }
}

// MARK: - Modifier

struct RecentNewsCarouselViewModifier: ViewModifier {

    // MARK: - Property

    @State private var scrollOffset: CGFloat
    @State private var draggingOffset: CGFloat

    private let sections: Int
    private let sectionWidth: CGFloat
    private let sectionSpacing: CGFloat

    // MARK: - Initializer

    init(sections: Int, sectionWidth: CGFloat, sectionSpacing: CGFloat) {
        self.sections = sections
        self.sectionWidth = sectionWidth
        self.sectionSpacing = sectionSpacing
        
        // 表示要素全体の幅を定義する
        // 👉 (sectionWidth) × (Section個数) + (sectionSpacing) × (Section個数 - 1)
        let contentWidth: CGFloat = CGFloat(sections) * sectionWidth + CGFloat(sections - 1) * sectionSpacing
        let screenWidth = UIScreen.main.bounds.width

        // 一番最初の表示要素が画面の中央に配置されるようにオフセット値を調整する
        let initialOffset = (contentWidth / 2.0) - (screenWidth / 2.0) + ((screenWidth - sectionWidth) / 2.0)

        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        // 👉 ここでは初回時のオフセット位置とドラッグ処理時に格納される値を0にする
        _scrollOffset = State(initialValue: initialOffset)
        _draggingOffset = State(initialValue: 0)
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            // MEMO: (scrollOffset + draggingOffset) とすることで表示対象が中央にピッタリと合うようにしている
            .offset(x: scrollOffset + draggingOffset, y: 0)
            .gesture(
                DragGesture()
                // 👉 Carousel要素の移動中はStateと連動するdraggingOffset値を更新する
                .onChanged({ event in
                    draggingOffset = event.translation.width
                })
                // 👉 Carousel要素の移動終了時は自然に元の位置または動かそうとした位置に戻る様にしている
                .onEnded({ event in
                    // ドラッグ処理で動かした分をscrollOffsetに加算して、draggingOffsetは0に戻す
                    scrollOffset += event.translation.width
                    draggingOffset = 0
                    
                    // 内部計算で利用するために計算表示要素全体の幅を定義する
                    // 👉 (sectionWidth) × (Section個数) + (sectionSpacing) × (Section個数 - 1)
                    let contentWidth: CGFloat = CGFloat(sections) * sectionWidth + CGFloat(sections - 1) * sectionSpacing
                    let screenWidth = UIScreen.main.bounds.width

                    // scrollOffsetの値を元にして配置要素の中央値を算出する
                    let center = scrollOffset + (screenWidth / 2.0) + (contentWidth / 2.0)
                    
                    // scrollOffsetの値を元にして配置要素の中央値から表示されるであろうindex値を計算値から算出する
                    var index = (center - (screenWidth / 2.0)) / (sectionWidth + sectionSpacing)

                    // 指を離した際に半分以上か否かで次のindex値の要素を表示するかを決定する
                    if index.remainder(dividingBy: 1) > 0.5 {
                        index += 1
                    } else {
                        index = CGFloat(Int(index))
                    }

                    // 現在のインデックス値が0〜一番最後のインデックス値を超過しないように調整する
                    index = min(index, CGFloat(sections) - 1)
                    index = max(index, 0)

                    // ドラッグ移動処理で移動させる値を決定する
                    let newOffset = index * sectionWidth + (index - 1) * sectionSpacing - (contentWidth / 2.0) + (screenWidth / 2.0) - ((screenWidth - sectionWidth) / 2.0) + sectionSpacing

                    // これまでの処理で算出したオフセット値を反映する際にアニメーション処理を伴うようにする
                    withAnimation {
                        scrollOffset = newOffset
                    }
                })
            )
    }
}

// MARK: - Preview

struct RecentNewsCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        RecentNewsCarouselView()
    }
}
