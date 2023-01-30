//
//  ArchiveScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI

struct ArchiveScreenView: View {

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                ArchiveContentsView(
                    archiveCellViewObjects: getArchiveCellViewObjects(),
                    tapCategoryChipAction: { _ in
                        // TODO: Category表示Chipを謳歌した際のアクション伝播処理を記載する
                    },
                    tapFavioriteButtonAction: { viewObject, shouldFavorite in
                        print("想定: Tap処理を実行した際に何らかの処理を実行する (ID:\(viewObject.id))")
                        print("想定: お気に入りから登録[true] or 削除[false] (ID:\(shouldFavorite))")
                    }
                )
            }
            .navigationTitle("Archive")
            .navigationBarTitleDisplayMode(.inline)
            // Debug. APIとの疎通確認（※後程削除する）
            .onFirstAppear {
                Task {
                    do {
                        let result = try await ApiClientManager.shared.getAchiveImages(keyword: "ベトナム", category: "エスニック料理")
                        print("成功")
                        dump(result)
                    } catch APIError.error(let message) {
                        print("失敗")
                        print(message)
                    }
                }
            }
        }
    }
}

// MARK: ArchiveScreenView Extension

extension ArchiveScreenView {
    
    // MARK: - Private Function

    private func getArchiveCellViewObjects() -> [ArchiveCellViewObject] {

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
        return archiveCellViewObjects
    }

    private func getArchiveSceneResponse() -> ArchiveSceneResponse {
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

// MARK: - Preview

struct ArchiveScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveScreenView()
    }
}
