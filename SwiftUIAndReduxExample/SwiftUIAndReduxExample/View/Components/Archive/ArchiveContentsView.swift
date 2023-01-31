//
//  ArchiveContentsView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/29.
//

import SwiftUI

struct ArchiveContentsView: View {

    // MARK: - Typealias

    typealias TapFavioriteButtonAction = (ArchiveCellViewObject, Bool) -> Void

    // MARK: - Property

    // MEMO: 画面に表示する内容を格納するための変数
    @State private var archiveCellViewObjects: [ArchiveCellViewObject] = []

    // 親のViewから受け取った検索キーワードを格納するための変数
    private var targetKeyword: String

    // 親のViewから受け取ったカテゴリー名を格納するための変数
    private var targetCategory: String

    // Favoriteボタン（ハート型ボタン要素）タップ時にArchiveCellViewに引き渡すClosure変数
    private var tapFavioriteButtonAction: ArchiveContentsView.TapFavioriteButtonAction

    // MARK: - Initializer

    init(
        archiveCellViewObjects: [ArchiveCellViewObject],
        targetKeyword: String = "",
        targetCategory: String = "",
        tapFavioriteButtonAction: @escaping TapFavioriteButtonAction
    ) {
        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        _archiveCellViewObjects = State(initialValue: archiveCellViewObjects)

        // ArchiveCellViewに検索キーワードをハイライトする文字列の初期化
        self.targetKeyword = targetKeyword
        // ArchiveCellViewにカテゴリーをハイライトする文字列の初期化
        self.targetCategory = targetCategory
        //　Favoriteボタン（ハート型ボタン要素）タップ時のClosureの初期化
        self.tapFavioriteButtonAction = tapFavioriteButtonAction
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            ForEach(archiveCellViewObjects) { viewObject in
                ArchiveCellView(
                    viewObject: viewObject,
                    targetKeyword: targetKeyword,
                    targetCategory: targetCategory,
                    tapFavioriteButtonAction: { shouldFavorite in
                        // 👉 Favoriteボタン（ハート型ボタン要素）タップ時に実行されるClosure
                        tapFavioriteButtonAction(viewObject, shouldFavorite)
                    }
                )
            }
        }
    }
}

// MARK: - Preview

struct ArchiveContentsView_Previews: PreviewProvider {
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

        // Preview: ArchiveContentsView
        ArchiveContentsView(
            archiveCellViewObjects: archiveCellViewObjects,
            targetKeyword: "",
            targetCategory: "",
            tapFavioriteButtonAction: { _,_  in }
        )
        .previewDisplayName("ArchiveContentsView Preview")
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
