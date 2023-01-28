//
//  TrendArticlesGridView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/10.
//

import SwiftUI
import Kingfisher

struct TrendArticlesGridView: View {

    // MARK: - Property

    // MEMO: 片方のSpacing値を8.0、もう一方を0.0にして調整している（これが正解かは自信はないです😢）
    private let gridColumns = [
        GridItem(spacing: 8.0),
        GridItem(spacing: 0.0)
    ]

    private let screen = UIScreen.main.bounds

    private var screenWidth: CGFloat {
        return screen.width
    }

    private var standardWidth: CGFloat {
        // MEMO: 間隔は8.0×3=24.0と想定しています
        return CGFloat((screen.width - 24.0) / 2)
    }

    private var standardHeight: CGFloat {
        return CGFloat(standardWidth / 1.5) + 94.0
    }

    // MEMO: LazyVGridに表示する内容を格納するための変数
    @State private var trendArticlesGridViewObjects: [TrendArticlesGridViewObject] = []

    // MARK: - Initializer

    init(trendArticlesGridViewObjects: [TrendArticlesGridViewObject]) {

        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        _trendArticlesGridViewObjects = State(initialValue: trendArticlesGridViewObjects)
    }

    // MARK: - Body

    var body: some View {
        VStack {
            // MEMO: 上下に8.0の行間をつけるためにSpacing値を8.0としています。
            LazyVGrid(columns: gridColumns, spacing: 8.0) {
                ForEach(trendArticlesGridViewObjects) { viewObject in
                    // MEMO: TrendArticlesGridViewTrendとTrendArticlesCellViewのstandardWidthとstandardHeightは合わせています。
                    TrendArticlesCellView(viewObject: viewObject, tapCellAction: {
                        print("想定: Tap処理を実行した際に何らかの処理を実行する (ID:\(viewObject.id))")
                    })
                    .frame(height: standardHeight)
                }
            }
            // MEMO: 全体の左右にもそれぞれ8.0の行間をつけるためVStackの中にLazyVGridを入れて左右のpadding値を8.0としています。
            .padding([.leading, .trailing], 8.0)
        }
        .frame(width: screenWidth)
    }
}

// MARK: - TrendArticlesCellView

struct TrendArticlesCellView: View {

    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var thumbnailWidth: CGFloat {
        // MEMO: 間隔は8.0×3=24.0と想定しています
        return CGFloat((screen.width - 24.0) / 2)
    }

    private var thumbnailHeight: CGFloat {
        return CGFloat(standardWidth / 1.5)
    }

    private var standardWidth: CGFloat {
        return thumbnailWidth
    }

    private var standardHeight: CGFloat {
        return thumbnailHeight + 94.0
    }

    private var cellTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 14)
    }

    private var cellIntroductionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var cellThumbnailMaskColor: Color {
        return Color.black.opacity(0.36)
    }
    
    private var cellTitleColor: Color {
        return Color.white
    }

    private var cellIntroductionColor: Color {
        return Color.primary
    }

    private var cellRoundRectangleColor: Color {
        return Color.secondary.opacity(0.5)
    }

    private var viewObject: TrendArticlesGridViewObject
    private var tapCellAction: TapCellAction

    // MARK: - Typealias

    typealias TapCellAction = () -> Void

    // MARK: - Initializer

    init(
        viewObject: TrendArticlesGridViewObject,
        tapCellAction: @escaping TapCellAction
    ) {
        self.viewObject = viewObject
        self.tapCellAction = tapCellAction
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            // (1) 上部の画面要素とテキストを重ねて表示する部分
            // 👉 ZStack内部の要素についてはサムネイル表示のサイズと合わせています。
            ZStack {
                KFImage(viewObject.thumbnailUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: thumbnailWidth, height: thumbnailHeight)
                Rectangle()
                    .foregroundColor(cellThumbnailMaskColor)
                    .frame(width: thumbnailWidth, height: thumbnailHeight)
                VStack {
                    Spacer()
                    Text(viewObject.title)
                        .font(cellTitleFont)
                        .foregroundColor(cellTitleColor)
                        .padding([.leading, .trailing], 8.0)
                        .padding([.bottom], 8.0)
                        .lineLimit(2)
                }
                .frame(width: thumbnailWidth, height: thumbnailHeight)
            }
            // (2) 下部のテキスト表示
            VStack {
                Text(viewObject.introduction)
                    .font(cellIntroductionFont)
                    .foregroundColor(cellIntroductionColor)
                    .padding([.leading, .trailing], 8.0)
                    .padding([.bottom], 2.0)
                    .padding([.top], 2.0)
                    .lineSpacing(2.0)
                    .lineLimit(4)
            }
            // (3) 上に要素を詰めるためのSpacer
            Spacer()
        }
        // MEMO: タップ領域の確保とタップ時の処理
        .contentShape(Rectangle())
        .onTapGesture(perform: tapCellAction)
        .cornerRadius(8.0)
        .frame(width: standardWidth, height: standardHeight)
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(cellRoundRectangleColor)
        )
    }
}

// MARK: - Preview

struct TrendArticlesGridView_Previews: PreviewProvider {
    static var previews: some View {

        // MEMO: Preview表示用にレスポンスを想定したJsonを読み込んで画面に表示させる
        let trendArticleResponse = getTrendArticleResponse()
        let trendArticlesGridViewObjects = trendArticleResponse.result
            .map {
                TrendArticlesGridViewObject(
                    id: $0.id,
                    thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                    title: $0.title,
                    introduction: $0.introduction,
                    publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
                )
            }

        // Preview: TrendArticlesGridView
        TrendArticlesGridView(trendArticlesGridViewObjects: trendArticlesGridViewObjects)
            .previewDisplayName("TrendArticlesGridView Preview")

        // MEMO: 部品1つあたりを表示するためのViewObject
        let viewObject = TrendArticlesGridViewObject(
            id: 1,
            thumbnailUrl: URL(string: "https://ones-mind-topics.s3.ap-northeast-1.amazonaws.com/trend_article1.jpg") ?? nil,
            title: "クリスマスの料理に関する思い出(1)",
            introduction: "子供の頃はクリスマスを楽しみにしていた思い出を大人になった今でも覚えている方は沢山いらっしゃるかもしれません。また、家族と一緒に料理をする機会が多いご家庭の中ではこの機会が貴重な一家団欒の場となっていたことでしょう。今回はクリスマスが近いシーズンにピッタリな「心温まるクリスマスに因んだストーリー」をいくつかご紹介できればと思います🎄",
            publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: "2022-12-01T07:30:00.000+0000")
        )

        // Preview: TrendArticlesCellView
        TrendArticlesCellView(viewObject: viewObject, tapCellAction: {})
            .previewDisplayName("TrendArticlesCellView Preview")
    }
    
    // MARK: - Private Static Function

    private static func getTrendArticleResponse() -> TrendArticleResponse {
        guard let path = Bundle.main.path(forResource: "trend_articles", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([TrendArticleEntity].self, from: data) else {
            fatalError()
        }
        return TrendArticleResponse(result: result)
    }
}
