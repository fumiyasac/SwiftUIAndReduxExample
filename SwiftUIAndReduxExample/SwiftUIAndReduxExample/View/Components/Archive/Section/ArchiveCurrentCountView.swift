//
//  ArchiveCurrentCountView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/09.
//

import SwiftUI

struct ArchiveCurrentCountView: View {

    // MARK: - Typealias

    typealias TapAllClearAction = () -> Void

    // MARK: - Property

    private var currentCountTitleFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var currentCountTitleColor: Color {
        return Color.primary
    }

    private var allClearButtonTitleFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var allClearButtonTitleColor: Color {
        return Color.primary
    }

    private var currentCount: Int
    private var tapAllClearAction: ArchiveCurrentCountView.TapAllClearAction

    // MARK: - Initializer

    init(
        currentCount: Int,
        tapAllClearAction: @escaping ArchiveCurrentCountView.TapAllClearAction
    ) {
        self.currentCount = currentCount
        self.tapAllClearAction = tapAllClearAction
    }

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
                Button(action: tapAllClearAction, label: {
                    Text("▶︎条件をクリア")
                        .font(allClearButtonTitleFont)
                        .foregroundColor(allClearButtonTitleColor)
                        .underline()
                })
            }
            .padding([.leading, .trailing], 12.0)
        }
    }
}

struct ArchiveCurrentCountView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveCurrentCountView(currentCount: 36, tapAllClearAction: {})
    }
}
