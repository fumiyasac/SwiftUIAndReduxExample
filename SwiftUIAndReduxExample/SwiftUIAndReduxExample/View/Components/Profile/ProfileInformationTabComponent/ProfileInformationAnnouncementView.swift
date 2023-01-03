//
//  ProfileInformationAnnouncementView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/02.
//

import SwiftUI

struct ProfileInformationAnnouncementView: View {

    // MARK: - Initializer

    init() {}
    
    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0 ..< 5 , id: \.self) { _ in
                ProfileInformationAnnouncementCellView()
            }
        }
    }
}

// TODO: ViewObject込みのリファクタリングを実施する
struct ProfileInformationAnnouncementCellView: View {

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
            Text("App運営事務局からのお知らせ")
                .font(cellTitleFont)
                .foregroundColor(cellTitleColor)
                .lineLimit(1)
                .padding([.top], 4.0)
            Text("カテゴリー: 公式情報")
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
                Text("最新バージョンでは細かなアプリ内の機能改善対応と新たに加入をして下さった生産者様と店舗様の情報が閲覧できる様になりました！今後ともよろしくお願いします。")
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

struct ProfileInformationAnnouncementView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInformationAnnouncementView()
    }
}
