//
//  ProfileInformationView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/01.
//

import SwiftUI

struct ProfileInformationView: View {

    // MARK: - Property

    private var personalInformationDescriptionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var personalInformationDescriptionColor: Color {
        return Color.secondary
    }

    // MARK: - Initializer

    init() {}
    
    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            // 1. 概要文テキスト表示
            HStack {
                Text("気になっている店舗からの最新情報やあなた宛のコメント等を表示しています。定期的に更新されるので是非ともお見逃しなく確認してみて下さいね！")
                    .font(personalInformationDescriptionFont)
                    .foregroundColor(personalInformationDescriptionColor)
            }
            .padding([.bottom], 16.0)
            // 2. タブ型コンテンツ表示
            ProfileInformationTabSwitcher()
                .padding([.bottom], 8.0)
        }
        .padding([.leading, .trailing], 12.0)
    }
}

// MARK: - Preview

struct ProfileInformationView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInformationView()
    }
}
