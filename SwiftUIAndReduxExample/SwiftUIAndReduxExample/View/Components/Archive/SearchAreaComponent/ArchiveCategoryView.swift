//
//  ArchiveCategoryView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/04.
//

import SwiftUI

struct ArchiveCategoryView: View {

    // MARK: - Property

    private var categorySliderTitleFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var categorySliderTitleColor: Color {
        return Color.primary
    }

    private var categoryBorderColor: Color {
        return Color(uiColor: AppConstants.ColorPalette.mint)
    }

    private var normalCategoryFont: Font {
        return Font.custom("AvenirNext-Regular", size: 13)
    }

    private var normalCategoryTintColor: Color {
        return Color.gray
    }

    private var normalCategoryBackgroudColor: Color {
        return Color.white
    }
    
    private var selectedCategoryFont: Font {
        return Font.custom("AvenirNext-Bold", size: 13)
    }

    private var selectedCategoryTintColor: Color {
        return Color.white
    }

    private var selectedCategoryBackgroudColor: Color {
        return Color(uiColor: AppConstants.ColorPalette.mint)
    }
    
    @Binding var selectedCategory: String

    // MARK: - Body

    // TODO: 実際のデータを入れた上での本実装が必要
    var body: some View {
        VStack(spacing: 0.0) {
            HStack {
                Text("カテゴリー検索:")
                    .font(categorySliderTitleFont)
                    .foregroundColor(categorySliderTitleColor)
                    .padding([.top], 8.0)
                Spacer()
            }
            // カテゴリー一覧表示に関連する部分
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8.0) {
                        ForEach(0 ..< 6, id: \.self) { index in
                            // TODO: 表示のための仮ロジック
                            let number = index + 1
                            let categoryName = "Category\(number)"
                            let selected = (selectedCategory == categoryName)
                            // Category表示用のChip型部分
                            VStack(alignment: .leading) {
                                Text(categoryName)
                                    .font(selected ? selectedCategoryFont : normalCategoryFont)
                                    .foregroundColor(selected ? selectedCategoryTintColor : normalCategoryTintColor)
                                    .padding([.leading, .trailing], 12.0)
                                    .padding([.top, .bottom], 6.0)
                            }
                            .background(selected ? selectedCategoryBackgroudColor :  normalCategoryBackgroudColor)
                            // MEMO: 角丸にしたい場合には.cornerRadiusと.overlayを両方設定する必要がある
                            .cornerRadius(24.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24.0)
                                    .stroke(categoryBorderColor, lineWidth: 1.0)
                            )
                        }
                    }
                }
            }
            .frame(height: 44.0)
        }
        .padding([.leading, .trailing], 12.0)
    }
}

// MARK: - Preview

struct ArchiveCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveCategoryView(selectedCategory: .constant("Category1"))
    }
}
