//
//  FeaturedTopicsCarouselView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/10.
//

import SwiftUI
import Kingfisher

struct FeaturedTopicsCarouselView: View {
    
    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var screenWidth: CGFloat {
        return screen.width
    }

    // MEMO: LazyHStackに表示する内容を格納するための変数
    private let featuredTopicsCarouselViewObjects: [FeaturedTopicsCarouselViewObject]

    // MARK: - Initializer

    init(featuredTopicsCarouselViewObjects: [FeaturedTopicsCarouselViewObject]) {
        self.featuredTopicsCarouselViewObjects = featuredTopicsCarouselViewObjects
    }

    // MARK: - Body

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                // MEMO: 表示要素の間に8.0の行間をつけるためにSpacing値を8.0としています。
                LazyHStack(spacing: 8.0) {
                    ForEach(featuredTopicsCarouselViewObjects) { viewObject in
                        FeaturedTopicsCellView(
                            viewObject: viewObject,
                            tapCellAction: {
                                print("想定: Tap処理を実行した際に何らかの処理を実行する (ID:\(viewObject.id))")
                            }
                        )
                    }
                }
            }
            .padding([.leading, .trailing], 8.0)
        }
        .frame(width: screenWidth)
    }
}

// MARK: - PickupPhotosCellView

struct FeaturedTopicsCellView: View {

    // MARK: - Property

    private var thumbnailWidth: CGFloat {
        return 200.0
    }

    private var thumbnailHeight: CGFloat {
        return thumbnailWidth * 960.0 / 720.0
    }

    private var standardWidth: CGFloat {
        return thumbnailWidth
    }

    private var standardHeight: CGFloat {
        return thumbnailHeight + 100.0
    }

    private var cellUserPointFont: Font {
        return Font.custom("AvenirNext-Bold", size: 14)
    }

    private var cellRatingFont: Font {
        return Font.custom("AvenirNext-Bold", size: 18)
    }

    private var cellTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 12)
    }

    private var cellCaptionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var cellDateFont: Font {
        return Font.custom("AvenirNext-Bold", size: 11)
    }
    
    private var cellUserPointColor: Color {
        return Color.white
    }

    private var cellRatingColor: Color {
        return Color(uiColor: UIColor(code: "#ff5145"))
    }

    private var cellTitleColor: Color {
        return Color.primary
    }

    private var cellCaptionColor: Color {
        return Color.secondary
    }

    private var cellDateColor: Color {
        return Color.secondary
    }

    private var cellThumbnailMaskColor: Color {
        return Color.black.opacity(0.36)
    }

    private var cellThumbnailRoundRectangleColor: Color {
        return Color.secondary.opacity(0.5)
    }

    private var viewObject: FeaturedTopicsCarouselViewObject
    private var tapCellAction: TapCellAction

    // MARK: - Typealias

    typealias TapCellAction = () -> Void

    // MARK: - Initializer

    init(
        viewObject: FeaturedTopicsCarouselViewObject,
        tapCellAction: @escaping TapCellAction
    ) {
        self.viewObject = viewObject
        self.tapCellAction = tapCellAction
    }

    var body: some View {
        VStack(alignment: .leading) {
            // (1) 上部の画面要素とテキストや星形レーティングを重ねて表示する部分
            // 👉 ZStack内部の要素についてはサムネイル表示のサイズと合わせています。
            ZStack {
                KFImage(viewObject.thumbnailUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(width: thumbnailWidth, height: thumbnailHeight)
                    .cornerRadius(8.0)
                Rectangle()
                    .foregroundColor(cellThumbnailMaskColor)
                    .frame(width: thumbnailWidth, height: thumbnailHeight)
                    .cornerRadius(8.0)
                VStack {
                    Spacer()
                    // MEMO: 星形レーティング表示部分はRatingViewRepresentableと橋渡しをするStarRatingViewを経由して表示する
                    // 👉 RatingViewRepresentable.swiftでUIKit製のライブラリで提供している「Cosmos」を利用できる様にしています。
                    StarRatingView(rating: viewObject.rating)
                    HStack {
                        Text("ユーザー評価:")
                            .font(cellUserPointFont)
                            .foregroundColor(cellUserPointColor)
                            .lineLimit(1)
                        Text(String(format: "%.1f", viewObject.rating))
                            .font(cellRatingFont)
                            .foregroundColor(cellRatingColor)
                            .lineLimit(1)
                    }
                    .padding([.bottom], 8.0)

                }
                .frame(width: thumbnailWidth, height: thumbnailHeight)
            }
            // (2) 下部のテキスト表示（タイトル表示）
            Text(viewObject.title)
                .font(cellTitleFont)
                .foregroundColor(cellTitleColor)
                .padding([.top], 2.0)
                .padding([.leading, .trailing], 8.0)
                .padding([.bottom], 2.0)
                .lineLimit(1)
            // (3) 下部のテキスト表示（キャプション表示）
            Text(viewObject.caption)
                .font(cellCaptionFont)
                .foregroundColor(cellCaptionColor)
                .padding([.top], -2.0)
                .padding([.leading, .trailing], 8.0)
                .lineSpacing(2.0)
                .lineLimit(2)
            // (4) 下部のテキスト表示（日付表示）
            HStack {
                Spacer()
                Text(viewObject.publishedAt)
                    .font(cellDateFont)
                    .foregroundColor(cellDateColor)
                    .padding([.top], -6.0)
                    .padding([.leading, .trailing], 8.0)
                    .lineLimit(1)
            }
            // (5) Spacer
            Spacer()
        }
        // MEMO: タップ領域の確保とタップ時の処理
        .contentShape(Rectangle())
        .onTapGesture(perform: tapCellAction)
        .frame(width: standardWidth, height: standardHeight)
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(cellThumbnailRoundRectangleColor)
        )
    }
}

// MARK: - StarRatingView

struct StarRatingView: View {

    // MARK: - Property

    @State private var rating: Double = 0.0

    // MARK: - Initializer

    init(rating: Double) {
        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        _rating = State(initialValue: rating)
    }

    // MARK: - Body

    var body: some View {
        // MEMO: ライブラリ「Cosmos」のView要素にイニシャライザで受け取った値を反映する
        RatingViewRepresentable(rating: $rating)
    }
}

// MARK: - Preview

struct FeaturedTopicsCarouselView_Previews: PreviewProvider {
    static var previews: some View {

        // MEMO: Preview表示用にレスポンスを想定したJsonを読み込んで画面に表示させる
        let featuredTopicsResponse = getFeaturedTopicsResponse()
        let featuredTopicsCarouselViewObjects = featuredTopicsResponse.result
            .map {
                FeaturedTopicsCarouselViewObject(
                    id: $0.id,
                    rating: $0.rating,
                    thumbnailUrl: URL(string: $0.thumbnailUrl) ?? nil,
                    title: $0.title,
                    caption: $0.caption,
                    publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
                )
            }

        // Preview: FeaturedTopicsCarouselView
        FeaturedTopicsCarouselView(featuredTopicsCarouselViewObjects: featuredTopicsCarouselViewObjects)
            .previewDisplayName("FeaturedTopicsCarouselView Preview")
    
        // MEMO: 部品1つあたりを表示するためのViewObject
        let viewObject = FeaturedTopicsCarouselViewObject(
            id: 1,
            rating: 3.7,
            thumbnailUrl: URL(string: "https://ones-mind-topics.s3.ap-northeast-1.amazonaws.com/featured_topic1.jpg") ?? nil,
            title: "ボリューム満点の洋食セット",
            caption: "この満足感はそう簡単には味わえないがうまい😆",
            publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: "2022-12-01T07:30:00.000+0000")
        )

        // Preview: FeaturedTopicsCellView
        FeaturedTopicsCellView(viewObject: viewObject, tapCellAction: {})
            .previewDisplayName("FeaturedTopicsCellView Preview")

        // MEMO: Preview表示用にレスポンスを想定したJsonを読み込んで画面に表示させる
        StarRatingView(rating: 3.76)
            .previewDisplayName("StarRatingView Preview")
    }
    
    // MARK: - Private Static Function

    private static func getFeaturedTopicsResponse() -> FeaturedTopicsResponse {
        guard let path = Bundle.main.path(forResource: "featured_topics", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([FeaturedTopicEntity].self, from: data) else {
            fatalError()
        }
        return FeaturedTopicsResponse(result: result)
    }
}
