//
//  RecentNewsCarouselView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/07.
//

import SwiftUI
import Kingfisher

// MEMO: 中央寄せCarousel方式でのバナー表示の参考
// https://levelup.gitconnected.com/snap-to-item-scrolling-debccdcbb22f
// ※ 基本の骨格はこの記事で解説されているサンプルの通りではありますが、内部に表示する内容を応用しているイメージです。

struct RecentNewsCarouselView: View {

    // MARK: - Property

    private let screen = UIScreen.main.bounds
    private let baseSpacing: CGFloat = 16.0
    private let sectionSpacing: CGFloat = 16.0
    private let sectionHeight: CGFloat = 260.0

    private var sectionWidth: CGFloat {
        return screen.width - sectionSpacing
    }

    private var recentNewsCarouselViewObjects: [RecentNewsCarouselViewObject] = []

    // MEMO: Grid表示View要素に表示する内容を格納するための変数
    @State private var groupedRecentNewsCarouselViewObjects: [GroupedRecentNewsCarouselViewObject] = []

    // MARK: - Initializer

    init(recentNewsCarouselViewObjects: [RecentNewsCarouselViewObject]) {
        self.recentNewsCarouselViewObjects = recentNewsCarouselViewObjects

        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        // 👉 ここでは引数で受け取ったpickupPhotosGridViewObject配列を2つに分割する
        _groupedRecentNewsCarouselViewObjects = State(initialValue: getGroupedRecentNewsCarouselViewObjects())
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: baseSpacing) {
            // MEMO: 1つのCarousel用Sectionに対して3つのRecentNewsCellViewを上寄せで表示するためにForEachの入れ子構想にしている
            ForEach(groupedRecentNewsCarouselViewObjects) { groupedRecentNewsCarouselViewObject in
                VStack {
                    ForEach(0 ..< groupedRecentNewsCarouselViewObject.recentNewsCarouselViewObjects.count, id: \.self) { index in
                        let viewObject = groupedRecentNewsCarouselViewObject.recentNewsCarouselViewObjects[index]
                        RecentNewsCellView(viewObject: viewObject)
                        // MEMO: VStack内部で等間隔に並べたいので最後以外にはSpacerを追加する
                        if index < 2 {
                            Spacer()
                        }
                    }
                }
                .frame(width: sectionWidth, height: sectionHeight, alignment: .leading)
            }
        }
        // MEMO: DragGestureの値変化を利用したCarousel表示用のModifier定義
        // 👉 CampaignBannerCarouselViewとは異なりCarouselにまつわる処理のほとんどをModifierで実行するイメージ
        .modifier(
            RecentNewsCarouselViewModifier(sections: groupedRecentNewsCarouselViewObjects.count, sectionWidth: sectionWidth, sectionSpacing: sectionSpacing)
        )
    }

    // MARK: - Private Function

    private func getGroupedRecentNewsCarouselViewObjects() -> [GroupedRecentNewsCarouselViewObject] {
        var groupedArray: [GroupedRecentNewsCarouselViewObject] = []
        var temporaryArray: [RecentNewsCarouselViewObject] = []
        for (i, recentNewsCarouselViewObject) in recentNewsCarouselViewObjects.enumerated() {
            if i % 3 == 2 || i == recentNewsCarouselViewObjects.count - 1 {
                temporaryArray.append(recentNewsCarouselViewObject)
                let recentNewsCarouselViewObjects = temporaryArray
                temporaryArray = []
                groupedArray.append(GroupedRecentNewsCarouselViewObject(id: UUID(), recentNewsCarouselViewObjects: recentNewsCarouselViewObjects))
            } else {
                temporaryArray.append(recentNewsCarouselViewObject)
            }
        }
        return groupedArray
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
            // MEMO: simultaneousGestureを利用してScrollView内で使用しても上下スクロールとの競合を発生しにくくする（とはいえ出てしまう時はあるかもしれない...）
            // 👉 こちらを利用した経緯としては、DragとTapを同時に実行する必要があったので、最初はhighPriorityGestureを利用したがTapが効かなかったので、simultaneousGestureを利用しています。
            // 参考リンク:
            // https://www.hackingwithswift.com/quick-start/swiftui/how-to-make-two-gestures-recognize-at-the-same-time-using-simultaneousgesture
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
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
                    withAnimation(.linear(duration: 0.12)) {
                        scrollOffset = newOffset
                    }
                })
            )
    }
}

// MARK: - RecentNewsCellView

struct RecentNewsCellView: View {

    // MARK: - Property

    private var cellCategoryFont: Font {
        return Font.custom("AvenirNext-Bold", size: 11)
    }

    private var cellDateFont: Font {
        return Font.custom("AvenirNext-Bold", size: 13)
    }

    private var cellTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 13)
    }

    private var cellCategoryColor: Color {
        return Color.white
    }

    private var cellCategoryBackgroundColor: Color {
        return Color(uiColor: UIColor(code: "#ff9900"))
    }

    private var cellDateColor: Color {
        return Color.secondary
    }

    private var cellTitleColor: Color {
        return Color.primary
    }

    private var cellThumbnailRoundRectangleColor: Color {
        return Color.secondary.opacity(0.5)
    }

    private var viewObject: RecentNewsCarouselViewObject

    // MARK: - Initializer

    init(viewObject: RecentNewsCarouselViewObject) {
        self.viewObject = viewObject
    }

    // MARK: - Body

    var body: some View {
        // MEMO: ちょっとこの辺は構造が強引で申し訳ないです...😢
        VStack(alignment: .leading) {
            // (1) VStackでTextを左寄せしている
            VStack {
                Text(viewObject.title)
                    .font(cellTitleFont)
                    .foregroundColor(cellTitleColor)
                    .lineLimit(1)
                    .padding([.leading, .trailing], 8.0)
                    .padding([.bottom], -10.0)
                    .padding([.top], 6.0)
            }
            // (2) HStackで左寄せのサムネイル画像とカテゴリーと日付を入れたVStackを組み合わせている
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    KFImage(viewObject.thumbnailUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .frame(width: 48.0, height: 48.0)
                        .background(
                            RoundedRectangle(cornerRadius: 4.0)
                                .stroke(cellThumbnailRoundRectangleColor)
                        )
                }
                .padding([.leading, .top], 8.0)
                VStack(alignment: .leading) {
                    Spacer()
                    Text(viewObject.newsCategory)
                        .font(cellCategoryFont)
                        .foregroundColor(cellCategoryColor)
                        .padding(3.0)
                        .background(cellCategoryBackgroundColor)
                    Text(DateLabelFormatter.getDateStringFromAPI(apiDateString: viewObject.publishedAt))
                        .font(cellDateFont)
                        .foregroundColor(cellDateColor)
                }
                .padding([.top], 8.0)
                .frame(height: 48.0)
            }
            // (3) Divider
            Divider()
                .frame(maxWidth: .infinity)
                .background(.gray)
                .padding([.leading, .trailing], 8.0)
                .padding([.top], 0.0)
        }
        // MEMO: タップ領域の確保とタップ時の処理
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            print("想定: Tap処理を実行した際に何らかの処理を実行する (ID:\(viewObject.id))")
        })
        .frame(height: 74.0)
    }
}

// MARK: - ViewObject

struct GroupedRecentNewsCarouselViewObject: Identifiable {
    let id: UUID
    let recentNewsCarouselViewObjects: [RecentNewsCarouselViewObject]
}

struct RecentNewsCarouselViewObject: Identifiable {
    let id: Int
    let thumbnailUrl: URL?
    let title: String
    let newsCategory: String
    let publishedAt: String
}

// MARK: - Preview

struct RecentNewsCarouselView_Previews: PreviewProvider {
    static var previews: some View {

        // MEMO: Preview表示用にレスポンスを想定したJsonを読み込んで画面に表示させる
        let recentNewsResponse = getRecentNewsResponse()
        let recentNewsCarouselViewObjects = recentNewsResponse.result
            .map {
                RecentNewsCarouselViewObject(
                    id: $0.id,
                    thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                    title: $0.title,
                    newsCategory: $0.newsCategory,
                    publishedAt: $0.publishedAt
                )
            }

        // Preview: RecentNewsCarouselView
        RecentNewsCarouselView(recentNewsCarouselViewObjects: recentNewsCarouselViewObjects)
            .previewDisplayName("RecentNewsCarouselView Preview")
        
        // MEMO: 部品1つあたりを表示するためのViewObject
        let viewObject = RecentNewsCarouselViewObject(
            id: 1,
            thumbnailUrl: URL(string: "https://ones-mind-topics.s3.ap-northeast-1.amazonaws.com/news_thumbnail1.jpg") ?? nil,
            title: "美味しい玉ねぎの年末年始の対応について",
            newsCategory: "生産者からのお知らせ",
            publishedAt: "2022-12-01T07:30:00.000+0000"
        )

        // Preview: RecentNewsCellView
        RecentNewsCellView(viewObject: viewObject)
            .previewDisplayName("RecentNewsCellView Preview")
    }

    // MARK: - Private Static Function

    private static func getRecentNewsResponse() -> RecentNewsResponse {
        guard let path = Bundle.main.path(forResource: "recent_news", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let recentNewsResponse = try? JSONDecoder().decode(RecentNewsResponse.self, from: data) else {
            fatalError()
        }
        return recentNewsResponse
    }
}
