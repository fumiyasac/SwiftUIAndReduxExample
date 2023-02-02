//
//  ArchiveState.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/02.
//

import Foundation

struct ArchiveState: ReduxState, Equatable {

    // MARK: - Property

    // MEMO: 読み込み中状態
    var isLoading: Bool = false
    // MEMO: エラー状態
    var isError: Bool = false

    // MEMO: 検索用に必要なパラメーター値
    var inputText: String = ""
    var selectedCategory: String = ""

    // MEMO: Archive画面で利用する情報として必要なViewObject情報
    // ※ このコードではViewObjectとView表示要素のComponentが1:1対応となる想定で作っています。
    var archiveCellViewObjects: [ArchiveCellViewObject] = []

    // MARK: - Equatable

    static func == (lhs: ArchiveState, rhs: ArchiveState) -> Bool {
        return lhs.isLoading == rhs.isLoading
        && lhs.isError == rhs.isError
        && lhs.inputText == rhs.inputText
        && lhs.selectedCategory == rhs.selectedCategory
        && lhs.archiveCellViewObjects == rhs.archiveCellViewObjects
    }
}
