//
//  ProfileInformationCommentView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/02.
//

import SwiftUI

struct ProfileInformationCommentView: View {

    // MARK: - Initializer

    init() {}
    
    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0 ..< 5 , id: \.self) { _ in
                ProfileInformationCommentCellView()
            }
        }
    }
}

// TODO: ViewObject込みのリファクタリングを実施する
struct ProfileInformationCommentCellView: View {

    // MARK: - Property

    private var cellTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 13)
    }

    private var cellTitleColor: Color {
        return Color.primary
    }

    private var cellEmotionFont: Font {
        return Font.custom("AvenirNext-Bold", size: 11)
    }

    private var cellEmotionColor: Color {
        return Color.gray
    }

    private var cellDateFont: Font {
        return Font.custom("AvenirNext-Bold", size: 11)
    }

    private var cellDateColor: Color {
        return Color.gray
    }

    private var cellCommentFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var cellCommentColor: Color {
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
            Text("ご来店頂きありがとうございました！")
                .font(cellTitleFont)
                .foregroundColor(cellTitleColor)
                .lineLimit(1)
                .padding([.top], 4.0)
            Text("お気持ち: 😊感謝！")
                .font(cellEmotionFont)
                .foregroundColor(cellEmotionColor)
                .lineLimit(1)
                .padding([.top], -8.0)
            Text("公開日: \(DateLabelFormatter.getDateStringFromAPI(apiDateString: "2022-12-01T07:30:00.000+0000"))")
                .font(cellDateFont)
                .foregroundColor(cellDateColor)
                .lineLimit(1)
                .padding([.top], -8.0)
            HStack {
                Text("この度はご来店頂きまして本当にありがとうございました。当店のお料理はご堪能頂けましたでしょうか？今後ともお客様に驚きと感動をご提供できる様に精進して参りますので、是非店舗の方もフォロー頂けますと嬉しく思います。")
                    .lineLimit(2)
                    .font(cellCommentFont)
                    .foregroundColor(cellCommentColor)
                    .padding([.top], 2.0)
            }
            Divider()
                .background(cellBorderColor)
        }
    }
}

// MARK: - Preview

struct ProfileInformationCommentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInformationCommentView()
    }
}
