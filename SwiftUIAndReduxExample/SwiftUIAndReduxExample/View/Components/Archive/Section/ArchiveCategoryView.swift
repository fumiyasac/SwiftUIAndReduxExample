//
//  ArchiveCategoryView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/04.
//

import SwiftUI

struct ArchiveCategoryView: View {

    // MARK: - Typealias

    typealias TapCategoryChipAction = (String) -> Void

    // MARK: - Enum

    private enum searchCategories: String, CaseIterable {
        case ethnic = "エスニック料理"
        case korean = "韓国料理"
        case curry = "カレー"
        case chinese = "中華料理"
        case japanese = "和食"
        case western = "洋食"
    }

    // MARK: - Property

    private var categorySliderTitleFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var categorySliderTitleColor: Color {
        return Color.primary
    }

    private var categoryBorderColor: Color {
        return Color(uiColor: UIColor(code: "#b9d9c3"))
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
        return Color(uiColor: UIColor(code: "#b9d9c3"))
    }

    private let selectedCategory: String
    private let tapCategoryChipAction: ArchiveCategoryView.TapCategoryChipAction

    // MARK: - Initializer

    init(
        selectedCategory: String,
        tapCategoryChipAction: @escaping ArchiveCategoryView.TapCategoryChipAction
    ) {
        self.selectedCategory = selectedCategory
        self.tapCategoryChipAction = tapCategoryChipAction
    }

    // MARK: - Body

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
                        ForEach(0 ..< searchCategories.allCases.count, id: \.self) { index in
                            let targetCategoryName = searchCategories.allCases[index].rawValue
                            let selected = (selectedCategory == targetCategoryName)
                            // Category表示用のChip型部分
                            VStack(alignment: .leading) {
                                Text(targetCategoryName)
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
                            .onTapGesture(perform: {
                                if selected {
                                    tapCategoryChipAction("")
                                } else {
                                    tapCategoryChipAction(targetCategoryName)
                                }
                            })
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
        ArchiveCategoryView(selectedCategory: "", tapCategoryChipAction: { _ in })
            .previewDisplayName("ArchiveCategoryView (Default) Preview")
        ArchiveCategoryView(selectedCategory: "カレー", tapCategoryChipAction: { _ in })
            .previewDisplayName("ArchiveFreewordView (Selected) Preview")
    }
}
