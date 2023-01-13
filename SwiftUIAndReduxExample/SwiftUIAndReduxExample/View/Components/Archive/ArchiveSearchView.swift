//
//  ArchiveSearchView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/29.
//

import SwiftUI
import Kingfisher

struct ArchiveSearchView: View {

    // MARK: - Property

    // MEMO: 画面に表示する内容を格納するための変数
    @State private var archiveCellViewObjects: [ArchiveCellViewObject] = []

    // MARK: - Initializer

    init(archiveCellViewObjects: [ArchiveCellViewObject]) {

        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        _archiveCellViewObjects = State(initialValue: archiveCellViewObjects)
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            // (1) 検索機能部分
            Group {
                ArchiveFreewordView(inputText: .constant(""), isLoading: .constant(false))
                ArchiveCategoryView(selectedCategory: .constant("エスニック料理"))
                ArchiveCurrentCountView(currentCount: .constant(36))
            }
            // (2) 一覧データ表示部分
            ScrollView {
                ForEach(archiveCellViewObjects) { viewObject in
                    ArchiveCellView(viewObject: viewObject, tapButtonAction: {
                        print("想定: Tap処理を実行した際に何らかの処理を実行する (ID:\(viewObject.id))")
                    })
                }
            }
        }
    }
}

// MARK: - ArchiveCellView

struct ArchiveCellView: View {

    // MARK: - Typealias

    typealias TapButtonAction = () -> Void

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

    private var viewObject: ArchiveCellViewObject

    private var tapButtonAction: ArchiveCellView.TapButtonAction

    // MARK: - Initializer
    
    init(viewObject: ArchiveCellViewObject, tapButtonAction: @escaping ArchiveCellView.TapButtonAction) {
        self.viewObject = viewObject
        self.tapButtonAction = tapButtonAction
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
                    .frame(width: 64.0, height: 64.0)
                    .background(
                        RoundedRectangle(cornerRadius: 4.0)
                            .stroke(cellThumbnailRoundRectangleColor)
                    )
                // 1-(2). プロフィール用基本情報表示
                VStack(alignment: .leading) {
                    // 1-(2)-①. 料理名表示
                    Text(viewObject.dishName)
                        .font(cellTitleFont)
                        .foregroundColor(cellTitleColor)
                    // 1-(2)-②. 料理カテゴリー表示
                    Group {
                        Text("Category: ") + Text(viewObject.category)
                    }
                    .font(cellCategoryFont)
                    .foregroundColor(cellCategoryColor)
                    .padding([.top], -8.0)
                    // 1-(2)-③. お店名表示
                    Group {
                        Text("Shop: ") + Text(viewObject.shopName)
                    }
                    .font(cellShopNameFont)
                    .foregroundColor(cellShopNameColor)
                    .padding([.top], -8.0)
                }
                .padding([.leading], 12.0)
                // 1-(3). Spacer
                Spacer()
                // 1-(4). お気に入りボタン
                Button(action: tapButtonAction, label: {
                    Image(systemName: "heart")
                })
                .foregroundColor(cellStockActiveButtonColor)
                .buttonStyle(PlainButtonStyle())
                .frame(width: 24.0, height: 32.0)
            }
            // 2. 概要テキストの情報表示部分
            HStack(spacing: 0.0) {
                Text(viewObject.introduction)
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
}

// MARK: - ViewObject

struct ArchiveCellViewObject: Identifiable {
    let id: Int
    let photoUrl: URL?
    let category: String
    let dishName: String
    let shopName: String
    let introduction: String
}

// MARK: - Preview

struct ArchiveSearchView_Previews: PreviewProvider {
    static var previews: some View {

        // MEMO: Preview表示用にレスポンスを想定したJsonを読み込んで画面に表示させる
        let achiveSceneResponse = getArchiveSceneResponse()
        let archiveCellViewObjects = achiveSceneResponse.result
            .map {
                ArchiveCellViewObject(
                    id: $0.id,
                    photoUrl: URL(string: $0.photoUrl) ?? nil,
                    category: $0.category,
                    dishName: $0.dishName,
                    shopName: $0.shopName,
                    introduction: $0.introduction
                )
            }

        // Preview: ArchiveSearchView
        ArchiveSearchView(archiveCellViewObjects: archiveCellViewObjects)
            .previewDisplayName("ArchiveSearchView Preview")

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
        ArchiveCellView(viewObject: viewObject, tapButtonAction: {})
            .previewDisplayName("ArchiveCellView Preview")
    }

    // MARK: - Private Static Function

    private static func getArchiveSceneResponse() -> ArchiveSceneResponse {
        guard let path = Bundle.main.path(forResource: "achive_images", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let achiveSceneResponse = try? JSONDecoder().decode(ArchiveSceneResponse.self, from: data) else {
            fatalError()
        }
        return achiveSceneResponse
    }
}
