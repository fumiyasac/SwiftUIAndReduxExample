//
//  OnboardingItemView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/05.
//

import SwiftUI

struct OnboardingItemView: View {

    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var screenWidth: CGFloat {
        return screen.width - 64.0
    }

    private var itemTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 24)
    }
    
    private var itemTitleColor: Color {
        return Color.white
    }

    private var itemSummaryFont: Font {
        return Font.custom("AvenirNext-Bold", size: 16)
    }
    
    private var itemSummaryColor: Color {
        return Color.white
    }

    private var itemThumbnailMaskColor: Color {
        return Color.black.opacity(0.16)
    }

    private var imageName: String
    private var title: String
    private var summary: String

    // MARK: - Initializer

    init(
        imageName: String,
        title: String,
        summary: String
    ) {
        self.imageName = imageName
        self.title = title
        self.summary = summary
    }

    // MARK: - Body

    var body: some View {
        // 👉 ZStack内部の要素についてはサムネイル表示のサイズと合わせています。
        ZStack {
            // (1) サムネイル画像表示
            Image(imageName)
                .resizable()
                .scaledToFill()
                // MEMO: .frameの後ろに.clippedを入れないとサムネイル画像が切り取られないので注意
                .frame(width: screenWidth)
                .clipped()
            // (2) 半透明マスク表示部分
            Rectangle()
                .foregroundColor(itemThumbnailMaskColor)
                .frame(width: screenWidth)
            // (3) タイトル＆サマリーテキスト表示部分
            VStack(spacing: 0.0) {
                HStack {
                    Text(title)
                        .font(itemTitleFont)
                        .foregroundColor(itemTitleColor)
                        .padding(.top, 24.0)
                        .padding(.horizontal, 16.0)
                    Spacer()
                }
                HStack {
                    Text(summary)
                        .font(itemSummaryFont)
                        .foregroundColor(itemSummaryColor)
                        .padding(.top, 8.0)
                        .padding(.horizontal, 16.0)
                        .padding(.bottom, 8.0)
                    Spacer()
                }
                Spacer()
            }
            .frame(width: screenWidth)
        }
        .frame(width: screenWidth)
    }
}

// MARK: - Preview

#Preview("OnboardingItemView Preview") {
    OnboardingItemView(
        imageName: "onboarding1",
        title: "Welcome to App.",
        summary: "アプリへようこそ！"
    )
}
