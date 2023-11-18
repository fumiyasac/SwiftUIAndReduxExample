//
//  ArchiveContentsView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/29.
//

import SwiftUI

struct ArchiveContentsView: View {

    // MARK: - Typealias

    typealias TapIsStoredButtonAction = (ArchiveCellViewObject, Bool) -> Void

    // MARK: - Property

    // 画面表示内容を格納するための変数
    private let archiveCellViewObjects: [ArchiveCellViewObject]

    // 親のViewから受け取った検索キーワードを格納するための変数
    private let targetKeyword: String

    // 親のViewから受け取ったカテゴリー名を格納するための変数
    private let targetCategory: String

    // Storeボタン（ハート型ボタン要素）タップ時にArchiveCellViewに引き渡すClosure変数
    private let tapIsStoredButtonAction: ArchiveContentsView.TapIsStoredButtonAction

    // MARK: - Initializer

    init(
        archiveCellViewObjects: [ArchiveCellViewObject],
        targetKeyword: String = "",
        targetCategory: String = "",
        tapIsStoredButtonAction: @escaping ArchiveContentsView.TapIsStoredButtonAction
    ) {
        // 画面表示内容を格納する配列の初期化
        self.archiveCellViewObjects = archiveCellViewObjects
        // ArchiveCellViewにカテゴリー及び検索キーワードをハイライトする文字列の初期化
        self.targetKeyword = targetKeyword
        self.targetCategory = targetCategory
        //　Storeボタン（ハート型ボタン要素）タップ時のClosureの初期化
        self.tapIsStoredButtonAction = tapIsStoredButtonAction
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            ForEach(archiveCellViewObjects) { viewObject in
                ArchiveCellView(
                    viewObject: viewObject,
                    targetKeyword: targetKeyword,
                    targetCategory: targetCategory,
                    tapIsStoredButtonAction: { isStored in
                        // 👉 Favoriteボタン（ハート型ボタン要素）タップ時に実行されるClosure
                        tapIsStoredButtonAction(viewObject, isStored)
                    }
                )
            }
        }
    }
}

// MARK: - Preview

#Preview("ArchiveContentsView Preview") {
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
    return ArchiveContentsView(
        archiveCellViewObjects: archiveCellViewObjects,
        targetKeyword: "",
        targetCategory: "",
        tapIsStoredButtonAction: { _,_  in }
    )

    // MARK: - Function

    func getArchiveSceneResponse() -> ArchiveSceneResponse {
        guard let path = Bundle.main.path(forResource: "achive_images", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ArchiveSceneEntity].self, from: data) else {
            fatalError()
        }
        return ArchiveSceneResponse(result: result)
    }
}
