//
//  ArchiveEmptyView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/02.
//

import SwiftUI

struct ArchiveEmptyView: View {

    // MARK: - Property

    private var archiveEmptyTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 18)
    }

    private var archiveEmptyTitleColor: Color {
        return Color.primary
    }

    private var archiveEmptyDescriptionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var archiveEmptyDescriptionColor: Color {
        return Color.secondary
    }

    // MARK: - body

    var body: some View {
        VStack(spacing: 0.0) {
            // (1) エラータイトル表示
            Text("エラー: 該当データがありません")
                .font(archiveEmptyTitleFont)
                .foregroundColor(archiveEmptyTitleColor)
                .padding([.bottom], 16.0)
            // (2) エラー文言表示
            HStack {
                Text("指定したカテゴリーや検索キーワードに合致するデータがありませんでした。カテゴリーの選択肢を変更したり、検索キーワードを変えて再度お試し下さい。")
                    .font(archiveEmptyDescriptionFont)
                    .foregroundColor(archiveEmptyDescriptionColor)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding([.leading, .trailing], 12.0)
    }
}

struct ArchiveEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveEmptyView()
    }
}
