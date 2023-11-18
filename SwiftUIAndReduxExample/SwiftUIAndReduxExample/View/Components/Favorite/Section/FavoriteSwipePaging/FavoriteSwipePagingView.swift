//
//  FavoriteSwipePagingView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/14.
//

import SwiftUI
import CollectionViewPagingLayout
import Kingfisher

// MEMO: OSSライブラリ「CollectionViewPagingLayout」を活用した変形Carousel表現
// https://github.com/amirdew/CollectionViewPagingLayout
// ※ CollectionViewPagingLayoutの中でStackPageViewを利用しています。
// ※ このライブラリはUIKitでも利用可能です。

struct FavoriteSwipePagingView: View {

    // MARK: - Property

    private let favoritePhotosCardViewObjects: [FavoritePhotosCardViewObject]

    // MARK: - Initializer

    init(favoritePhotosCardViewObjects: [FavoritePhotosCardViewObject]) {
        self.favoritePhotosCardViewObjects = favoritePhotosCardViewObjects
    }

    // MARK: - Body

    var body: some View {
        StackPageView(favoritePhotosCardViewObjects) { viewObject in
            FavoritePhotosCardView(viewObject: viewObject)
        }
        // MEMO: 要素をタップした際の処理を記載する
        // 👉 Closureから、ViewObject内のid値が渡ってくるのでこれを利用する形となります。
        .onTapPage({ id in
            print("想定: Tap処理を実行した際に何らかの処理を実行する (ID:\(id))")
        })
        // MEMO: Carousel表現の表示対象エリアを間隔値を設定する
        // 👉 真ん中の位置から上下左右に60を設定していますが、PreviewやBuildで確認して調整していく形になります。
        .pagePadding(
            vertical: .absolute(60),
            horizontal: .absolute(60)
        )
    }
}

// MARK: - FavoritePhotosCardView

struct FavoritePhotosCardView: View {
    
    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var cardWidth: CGFloat {
        return UIScreen.main.bounds.width - 72.0
    }
    
    private var cardHeight: CGFloat {
        return cardWidth * 1120 / 840
    }

    private var cardTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 16)
    }

    private var cardShopNameFont: Font {
        return Font.custom("AvenirNext-Bold", size: 13)
    }

    private var cardPublishedFont: Font {
        return Font.custom("AvenirNext-Bold", size: 10)
    }

    private var cardCategoryFont: Font {
        return Font.custom("AvenirNext-Bold", size: 10)
    }

    private var cardCommentFont: Font {
        return Font.custom("AvenirNext-Regular", size: 11)
    }

    private var cardAuthorFont: Font {
        return Font.custom("AvenirNext-Regular", size: 11)
    }
    
    private var cardThumbnailMaskColor: Color {
        return Color.black.opacity(0.46)
    }
    
    private var cardTitleColor: Color {
        return Color.white
    }

    private var cardShopNameColor: Color {
        return Color.white
    }

    private var cardPublishedColor: Color {
        return Color.white
    }

    private var cardCategoryColor: Color {
        return Color.white
    }

    private var cardCategoryBackgroundColor: Color {
        return Color(uiColor: UIColor(code: "#ffaa00"))
    }

    private var cardCommentColor: Color {
        return Color.white
    }

    private var cardAuthorColor: Color {
        return Color.white
    }
    
    private var cardRoundRectangleColor: Color {
        return Color.secondary.opacity(0.36)
    }
    
    private var viewObject: FavoritePhotosCardViewObject

    // MARK: - Initializer
    
    init(viewObject: FavoritePhotosCardViewObject) {
        self.viewObject = viewObject
    }

    // MARK: - Body
    
    var body: some View {
        // 上部の画面要素とテキストを重ねて表示する部分
        // 👉 ZStack内部の要素についてはサムネイル表示のサイズと合わせています。
        ZStack {
            // (1) サムネイル画像
            KFImage(viewObject.photoUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: cardWidth, height: cardHeight)
            // (2) 半透明の背景
            Rectangle()
                .foregroundColor(cardThumbnailMaskColor)
                .frame(width: cardWidth, height: cardHeight)
            // (3) サムネイル画像と半透明の背景の上に表示する要素群
            VStack(spacing: 0.0) {
                // (3)-1 タイトル表示
                Text(viewObject.title)
                    .font(cardTitleFont)
                    .foregroundColor(cardTitleColor)
                    .padding([.leading, .trailing], 12.0)
                    .padding([.top], 16.0)
                    .padding([.bottom], 12.0)
                    .lineLimit(1)
                    // MEMO: VStackのalignmentではなく.frameのalignmentで定めています。
                    // 👉 VStackのalignment: .leadingが効かなかったためにこうしました。
                    .frame(maxWidth: .infinity, alignment: .leading)
                // (3)-2 Divider
                Divider()
                    .background(.gray)
                    .padding([.leading, .trailing], 12.0)
                // (3)-3 投稿日＆カテゴリ表示
                HStack {
                    Text("投稿日: " + viewObject.publishedAt)
                        .font(cardPublishedFont)
                        .foregroundColor(cardPublishedColor)
                        .padding([.leading, .trailing], 12.0)
                        .padding([.top, .bottom], 8.0)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(viewObject.category)
                        .font(cardCategoryFont)
                        .foregroundColor(cardCategoryColor)
                        .padding([.leading, .trailing], 8.0)
                        .padding([.top, .bottom], 4.0)
                        .background(cardCategoryBackgroundColor)
                        .cornerRadius(12.0)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Spacer()
                        .frame(width: 12.0)
                }
                .frame(height: 36.0)
                // (3)-4 Divider
                Divider()
                    .background(.gray)
                    .padding([.leading, .trailing], 12.0)
                // (3)-5 店舗名表示
                Text(viewObject.shopName)
                    .font(cardShopNameFont)
                    .foregroundColor(cardShopNameColor)
                    .padding([.leading, .trailing], 12.0)
                    .padding([.top, .bottom], 8.0)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                // (3)-6 Divider
                Divider()
                    .background(.gray)
                    .padding([.leading, .trailing], 12.0)
                // (3)-7 コメント表示
                Text(viewObject.comment)
                    .font(cardCommentFont)
                    .foregroundColor(cardShopNameColor)
                    .padding([.leading, .trailing], 12.0)
                    .padding([.top], 8.0)
                    .padding([.bottom], 0.0)
                    .lineLimit(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                // (3)-8 作者表示
                Text("文章＆編集: " + viewObject.author)
                    .font(cardCommentFont)
                    .foregroundColor(cardCommentColor)
                    .padding([.leading, .trailing], 12.0)
                    .padding([.top], 8.0)
                    .padding([.bottom], 4.0)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                // (3)-9 Spacer
                Spacer()
            }
            .frame(width: cardWidth, height: cardHeight)
        }
        .cornerRadius(8.0)
        .frame(width: cardWidth, height: cardHeight)
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(cardRoundRectangleColor)
        )
    }
}

// MARK: - Preview

#Preview("FavoriteSwipePagingView Preview") {
    // MEMO: Preview表示用にレスポンスを想定したJsonを読み込んで画面に表示させる
    let favoriteSceneResponse = getFavoriteSceneResponse()
    let favoritePhotosCardViewObjects = favoriteSceneResponse.result
        .map {
            FavoritePhotosCardViewObject(
                id: $0.id,
                photoUrl: URL(string: $0.photoUrl) ?? nil,
                author: $0.author,
                title: $0.title,
                category: $0.category,
                shopName: $0.shopName,
                comment: $0.comment,
                publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt)
            )
        }
    // Preview: FavoriteSwipePagingView
    return FavoriteSwipePagingView(favoritePhotosCardViewObjects: favoritePhotosCardViewObjects)

    // MARK: - Function

    func getFavoriteSceneResponse() -> FavoriteSceneResponse {
        guard let path = Bundle.main.path(forResource: "favorite_scenes", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([FavoriteSceneEntity].self, from: data) else {
            fatalError()
        }
        return FavoriteSceneResponse(result: result)
    }
}

#Preview("FavoritePhotosCardView Preview") {
    // MEMO: 部品1つあたりを表示するためのViewObject
    let viewObject = FavoritePhotosCardViewObject(
        id: 1,
        photoUrl: URL(string: "https://ones-mind-topics.s3.ap-northeast-1.amazonaws.com/favorite_scene1.jpg") ?? nil,
        author: "編集部●●●●",
        title: "気になる一皿シリーズNo.1",
        category: "Special Contents",
        shopName: "サンプル店舗 No.1",
        comment: "（※このコメントはサンプルになります!）気になる一皿シリーズでは、読者の皆様がお店で「思わず感動を覚えてしまった思い出の一皿」をテーマに、美味しかったお料理の写真とコメントを掲載しています。行きつけのお店でのお気に入りの一品から、ちょっと贅沢をしたい時に仕事帰りに立ち寄るお店での思い出、大切な人と行く勝負レストランでの是非とも食べて欲しいお料理の思い出等、あなたとお料理のストーリーを是非とも教えてください！",
        publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: "2022-12-01T07:30:00.000+0000")
    )
    // Preview: FavoritePhotosCardView
    return FavoritePhotosCardView(viewObject: viewObject)
}
