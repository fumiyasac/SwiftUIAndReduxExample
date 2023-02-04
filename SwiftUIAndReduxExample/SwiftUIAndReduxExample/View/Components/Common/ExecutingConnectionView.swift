//
//  ExecutingConnectionView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/25.
//

import SwiftUI

struct ExecutingConnectionView: View {

    // MARK: - Property

    private var executingConnectionTitleFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var executingConnectionTitleColor: Color {
        return Color.secondary
    }

    private var executingConnectionBoxColor: Color {
        return Color.gray
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0.0) {
            // 1. Spacer
            Spacer()
            // 2. コンテンツ表示部分
            VStack {
                // (1) 読み込み中文言表示
                Text("読み込み中です...")
                    .font(executingConnectionTitleFont)
                    .foregroundColor(executingConnectionTitleColor)
                    .padding([.bottom], 4.0)
                // (2) Indicator表示
                LoadingIndicatorViewRepresentable(isLoading: .constant(true))
            }
            .frame(width: 122.0, height: 88.0)
            // MEMO: VStack自体に囲み線をつける対応
            // https://ios-docs.dev/stack-border/
            .overlay(
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(executingConnectionBoxColor, lineWidth: 1.0)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            // 3. Spacer
            Spacer()
        }
    }
}

struct ExecutingConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ExecutingConnectionView()
    }
}
