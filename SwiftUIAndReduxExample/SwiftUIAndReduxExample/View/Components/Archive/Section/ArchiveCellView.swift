//
//  ArchiveCellView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/31.
//

import SwiftUI
import Kingfisher

struct ArchiveCellView: View {

    // MARK: - Typealias

    typealias TapIsStoredButtonAction = (Bool) -> Void

    // MARK: - Property

    private var cellThumbnailRoundRectangleColor: Color {
        return Color.secondary.opacity(0.5)
    }

    private var cellTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 13)
    }

    private var cellTitleColor: Color {
        return Color.primary
    }

    private var cellCategoryFont: Font {
        return Font.custom("AvenirNext-Bold", size: 11)
    }

    private var cellCategoryColor: Color {
        return Color.secondary
    }

    private var cellShopNameFont: Font {
        return Font.custom("AvenirNext-Bold", size: 11)
    }

    private var cellShopNameColor: Color {
        return Color.secondary
    }

    private var cellIntroductionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 11)
    }

    private var cellIntroductionColor: Color {
        return Color.secondary
    }

    private var cellBorderColor: Color {
        return Color(uiColor: .lightGray)
    }

    private var cellStockInactiveButtonColor: Color {
        return Color(uiColor: .lightGray)
    }
    
    private var cellStockActiveButtonColor: Color {
        return Color.pink
    }

    private var highlightTextColor: Color {
        return Color.primary
    }

    private var highlightTextKeywordBackgroundColor: Color {
        return Color.yellow
    }

    private var highlightTextCategoryBackgroundColor: Color {
        return Color(uiColor: UIColor(code: "#ffc9d2"))
    }

    private var viewObject: ArchiveCellViewObject
    private var targetKeyword: String
    private var targetCategory: String
    private var tapIsStoredButtonAction: ArchiveCellView.TapIsStoredButtonAction

    // Favoriteボタン（ハート型ボタン要素）の状態を管理するための変数
    @State private var isStored: Bool = false

    // MARK: - Initializer

    init(
        viewObject: ArchiveCellViewObject,
        targetKeyword: String,
        targetCategory: String,
        tapIsStoredButtonAction: @escaping ArchiveCellView.TapIsStoredButtonAction
    ) {
        self.viewObject = viewObject
        self.targetKeyword = targetKeyword
        self.targetCategory = targetCategory
        self.tapIsStoredButtonAction = tapIsStoredButtonAction
        
        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        _isStored = State(initialValue: viewObject.isStored)
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            // 1. メインの情報表示部分
            HStack(spacing: 0.0) {
                // 1-(1). サムネイル用画像表示
                KFImage(viewObject.photoUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .cornerRadius(4.0)
                    .frame(width: 64.0, height: 64.0)
                    .background(
                        RoundedRectangle(cornerRadius: 4.0)
                            .stroke(cellThumbnailRoundRectangleColor)
                    )
                // 1-(2). 基本情報表示
                VStack(alignment: .leading) {
                    // 1-(2)-①. 料理名表示
                    Text(getAttributeBy(taregtText: viewObject.dishName, targetKeyword: targetKeyword))
                        .font(cellTitleFont)
                        .foregroundColor(cellTitleColor)
                    // 1-(2)-②. 料理カテゴリー表示
                    Group {
                        Text("Category: ") + Text(getAttributeBy(taregtText: viewObject.category, targetCategory: targetCategory))
                    }
                    .font(cellCategoryFont)
                    .foregroundColor(cellCategoryColor)
                    .padding([.top], -8.0)
                    // 1-(2)-③. お店名表示
                    Group {
                        Text("Shop: ") + Text(getAttributeBy(taregtText: viewObject.shopName, targetKeyword: targetKeyword))
                    }
                    .font(cellShopNameFont)
                    .foregroundColor(cellShopNameColor)
                    .padding([.top], -8.0)
                }
                .padding([.leading], 12.0)
                // 1-(3). Spacer
                Spacer()
                // 1-(4). お気に入りボタン
                Button(action: {
                    // 処理概要
                    // 👉 引き渡されたViewObject(ArchiveCellViewObject)のisStoredを @State に入れる
                    // 👉 ButtonがタップされたらisStoredのBool値が反転する
                    // 👉 このViewの @State が更新されるのでこのView内のお気に入り要素が変化する（全体の再レンダリングは実施しない）
                    isStored = !isStored
                    tapIsStoredButtonAction(isStored)
                }, label: {
                    if isStored {
                        Image(systemName: "heart.fill")
                    } else {
                        Image(systemName: "heart")
                    }
                })
                .foregroundColor(cellStockActiveButtonColor)
                .buttonStyle(PlainButtonStyle())
                .frame(width: 24.0, height: 32.0)
            }
            // 2. 概要テキストの情報表示部分
            HStack(spacing: 0.0) {
                Text(getAttributeBy(taregtText: viewObject.introduction, targetKeyword: targetKeyword))
                    .font(cellIntroductionFont)
                    .foregroundColor(cellIntroductionColor)
                    .padding([.vertical], 6.0)

            }
            // 3. 下側Divider
            Divider()
                .background(cellBorderColor)
        }
        .padding([.top], 4.0)
        .padding([.leading, .trailing], 12.0)
    }

    // MARK: - Private Function

    // 対象キーワードが含まれている文字列に対してテキストハイライトを指定する（json-serverの仕様に則った検索）
    // 参考: https://ios-docs.dev/attributedstring/
    private func getAttributeBy(taregtText: String, targetKeyword: String) -> AttributedString {
        var attributedString = AttributedString(taregtText)
        if let range = attributedString.range(of: targetKeyword) {
            attributedString[range].foregroundColor = highlightTextColor
            attributedString[range].backgroundColor = highlightTextKeywordBackgroundColor
        }
        return attributedString
    }

    private func getAttributeBy(taregtText: String, targetCategory: String) -> AttributedString {
        var attributedString = AttributedString(taregtText)
        if let range = attributedString.range(of: targetCategory) {
            attributedString[range].foregroundColor = highlightTextColor
            attributedString[range].backgroundColor = highlightTextCategoryBackgroundColor
        }
        return attributedString
    }
}

struct ArchiveCellView_Previews: PreviewProvider {
    static var previews: some View {
        // MEMO: 部品1つあたりを表示するためのViewObject
        let viewObject = ArchiveCellViewObject(
            id: 1,
            photoUrl: URL(string: "https://ones-mind-topics.s3.ap-northeast-1.amazonaws.com/archive_image1.jpg") ?? nil,
            category: "エスニック料理",
            dishName: "ベトナム風生春巻き",
            shopName: "美味しいベトナム料理のお店",
            introduction: "エスニック料理の定番メニュー！ちょっと甘酸っぱいピリ辛のソースとの相性が抜群です。"
        )

        // Preview: ArchiveCellView
        ArchiveCellView(viewObject: viewObject, targetKeyword: "ベトナム", targetCategory: "", tapIsStoredButtonAction: { _ in })
            .previewDisplayName("ArchiveCellView (with Search Keyword) Preview")

        ArchiveCellView(viewObject: viewObject, targetKeyword: "", targetCategory: "エスニック料理", tapIsStoredButtonAction: { _ in })
            .previewDisplayName("ArchiveCellView (with Search Category) Preview")

        // Preview: ArchiveCellView
        ArchiveCellView(viewObject: viewObject, targetKeyword: "", targetCategory: "", tapIsStoredButtonAction: { _ in })
            .previewDisplayName("ArchiveCellView (without Search Keyword) Preview")
    }
}
