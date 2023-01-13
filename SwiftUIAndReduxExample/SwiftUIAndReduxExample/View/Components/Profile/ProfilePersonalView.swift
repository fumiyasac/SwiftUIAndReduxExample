//
//  ProfilePersonalView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/30.
//

import SwiftUI

struct ProfilePersonalView: View {

    // MARK: - Property

    private var personNameFont: Font {
        return Font.custom("AvenirNext-Bold", size: 14)
    }

    private var personNameColor: Color {
        return Color.primary
    }

    private var personRegistrationFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var personRegistrationColor: Color {
        return Color.gray
    }

    private var personLastLoginFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var personLastLoginColor: Color {
        return Color.gray
    }

    private var viewHeight: CGFloat {
        return 86.0
    }

    // MARK: - Initializer

    init() {}

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HStack {
                // 1. プロフィール用アバター表示
                Image("profile_avatar_sample")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 58.0, height: 58.0)
                    .shadow(radius: 4.0)
                // 2. プロフィール用基本情報表示
                VStack(alignment: .leading) {
                    // 2-(1). ユーザー名表示
                    Text("料理人●●●●")
                        .font(personNameFont)
                        .foregroundColor(personNameColor)
                    // 2-(2). ユーザー登録日表示
                    Text("登録日: 2022.12.01")
                        .font(personRegistrationFont)
                        .foregroundColor(personRegistrationColor)
                        .padding([.top], -8.0)
                    // 2-(3). ユーザー最終ログイン日時表示
                    Text("最終ログイン: 2日前")
                        .font(personLastLoginFont)
                        .foregroundColor(personLastLoginColor)
                        .padding([.top], -8.0)
                }
                .padding([.leading], 8.0)
                Spacer()
            }
        }
        .padding([.leading, .trailing], 12.0)
        .frame(height: viewHeight)
    }
}

// MARK: - Preview

struct ProfilePersonalView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePersonalView()
    }
}
