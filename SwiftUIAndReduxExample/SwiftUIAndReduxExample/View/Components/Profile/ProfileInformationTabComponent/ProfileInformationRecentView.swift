//
//  ProfileInformationRecentView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/02.
//

import SwiftUI

struct ProfileInformationRecentView: View {

    // MARK: - Initializer

    init() {}
    
    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0 ..< 5 , id: \.self) { _ in
                ProfileInformationRecentCellView()
            }
        }
    }
}

// TODO: ViewObject込みのリファクタリングを実施する
struct ProfileInformationRecentCellView: View {

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

    private var cellDescriptionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var cellDescriptionColor: Color {
        return Color.secondary
    }

    private var cellBorderColor: Color {
        return Color(uiColor: .lightGray)
    }

    // MARK: - Initializer

    init() {}
    
    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            Text("和牛を使ったハンバーガーを40%OFFで販売中です✨")
                .font(cellTitleFont)
                .foregroundColor(cellTitleColor)
                .lineLimit(1)
                .padding([.top], 4.0)
            Text("カテゴリー: 新商品のご案内🍔")
                .font(cellCategoryFont)
                .foregroundColor(cellCategoryColor)
                .lineLimit(1)
                .padding([.top], -8.0)
            Text("公開日: \(DateLabelFormatter.getDateStringFromAPI(apiDateString: "2022-12-01T07:30:00.000+0000"))")
                .font(cellDateFont)
                .foregroundColor(cellDateColor)
                .lineLimit(1)
                .padding([.top], -8.0)
            HStack {
                Text("厚さ7.5cmの食べ応え十分のハンバーガーに固まりで仕入れた和牛を丁寧に叩いて作ったハンバーグを豪快にサンドした一品です！溢れんばかりの肉汁と当店で焼き上げているバンズのハーモニーを存分にお楽しみ下さい😊")
                    .lineLimit(2)
                    .font(cellDescriptionFont)
                    .foregroundColor(cellDescriptionColor)
                    .padding([.top], 2.0)
            }
            Divider()
                .background(cellBorderColor)
        }
    }
}

// MARK: - Preview

struct ProfileInformationRecentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInformationRecentView()
    }
}
