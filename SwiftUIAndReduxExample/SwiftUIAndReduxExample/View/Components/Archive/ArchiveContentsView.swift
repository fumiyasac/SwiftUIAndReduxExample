//
//  ArchiveContentsView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/29.
//

import SwiftUI

struct ArchiveContentsView: View {

    // MARK: - Property

    // MEMO: 画面に表示する内容を格納するための変数
    @State private var archiveCellViewObjects: [ArchiveCellViewObject] = []

    // MARK: - Typealias

    typealias TapCategoryChipAction = () -> Void
    typealias TapFavioriteButtonAction = () -> Void

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
                    ArchiveCellView(viewObject: viewObject, targetKeyword: "", tapButtonAction: {
                        print("想定: Tap処理を実行した際に何らかの処理を実行する (ID:\(viewObject.id))")
                    })
                }
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
        ArchiveContentsView(archiveCellViewObjects: archiveCellViewObjects)
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
