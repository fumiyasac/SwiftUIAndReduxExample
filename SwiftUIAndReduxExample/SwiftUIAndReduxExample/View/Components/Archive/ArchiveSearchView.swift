//
//  ArchiveSearchView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/29.
//

import SwiftUI

struct ArchiveSearchView: View {

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            // (1) 検索機能部分
            Group {
                ArchiveFreewordView(inputText: .constant(""))
                ArchiveCategoryView(selectedCategory: .constant("Category1"))
                ArchiveCurrentCountView(currentCount: .constant(36))
            }
            // (2) 一覧データ表示部分
            ScrollView {
                // TODO: 実際のデータを入れた上での本実装が必要
                ForEach(0 ..< 16 , id: \.self) { _ in
                    ArchiveCellView()
                }
            }
        }
    }
}

// MARK: - ArchiveCellView

struct ArchiveCellView: View {

    // MARK: - Property

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
        return Color.gray
    }

    private var cellDateFont: Font {
        return Font.custom("AvenirNext-Bold", size: 11)
    }

    private var cellDateColor: Color {
        return Color.gray
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

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            // メインの情報表示部分
            HStack(spacing: 0.0) {
                // 1. サムネイル用画像表示
                // TODO: KingFisherベースの設定に変更する
                Image("archive_sample_image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64.0, height: 64.0)
                // 2. プロフィール用基本情報表示
                VStack(alignment: .leading) {
                    // 2-(1). 料理名表示
                    Text("料理名が入ります")
                        .font(cellTitleFont)
                        .foregroundColor(cellTitleColor)
                    // 2-(2). 料理カテゴリー表示
                    Text("カテゴリー名: Category")
                        .font(cellCategoryFont)
                        .foregroundColor(cellCategoryColor)
                        .padding([.top], -8.0)
                    // 2-(3). ユーザー最終ログイン日時表示
                    Text("お店名: 美味しいお店")
                        .font(cellDateFont)
                        .foregroundColor(cellDateColor)
                        .padding([.top], -8.0)
                }
                .padding([.leading], 12.0)
                // 3. Spacer
                Spacer()
                // 4. お気に入りボタン
                Button(action: {
                    // TODO: ボタン押下時の処理
                }, label: {
                    Image(systemName: "heart")
                })
                .foregroundColor(cellStockActiveButtonColor)
                .buttonStyle(PlainButtonStyle())
                .frame(width: 24.0, height: 32.0)
            }
            // 概要テキストの情報表示部分
            HStack(spacing: 0.0) {
                Text("説明文が入ります。")
                    .font(cellDateFont)
                    .foregroundColor(cellDateColor)
                    .padding([.vertical], 6.0)

            }
            // 下側Divider
            Divider()
                .background(cellBorderColor)

        }
        .padding([.top], 4.0)
        .padding([.leading, .trailing], 12.0)
    }
}

// MARK: - Preview

struct ArchiveSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveSearchView()
    }
}
