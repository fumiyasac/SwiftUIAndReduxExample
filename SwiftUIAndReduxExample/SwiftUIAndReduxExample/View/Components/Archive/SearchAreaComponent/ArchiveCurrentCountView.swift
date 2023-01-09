//
//  ArchiveCurrentCountView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/09.
//

import SwiftUI

struct ArchiveCurrentCountView: View {

    // MARK: - Property

    private var currentCountTitleFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var currentCountTitleColor: Color {
        return Color.primary
    }

    // フリーワード検索用のTextFieldと連動する
    // 👉 この値が変化すると配置元のView要素の @State と連動して処理が実行される
    @Binding var currentCount: Int

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0.0) {
            HStack {
                Text("現在表示しているデータ: 全\(currentCount)件")
                    .font(currentCountTitleFont)
                    .foregroundColor(currentCountTitleColor)
                    .padding([.top], 2.0)
                    .padding([.bottom], 6.0)
                Spacer()
            }
            .padding([.leading, .trailing], 12.0)
        }
    }
}

struct ArchiveCurrentCountView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveCurrentCountView(currentCount: .constant(36))
    }
}
