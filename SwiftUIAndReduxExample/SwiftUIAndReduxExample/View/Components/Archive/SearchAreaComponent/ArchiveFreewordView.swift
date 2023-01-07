//
//  ArchiveFreewordView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/04.
//

import SwiftUI

struct ArchiveFreewordView: View {

    // MARK: - Property

    private var freewordTitleFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var freewordTitleColor: Color {
        return Color.primary
    }

    private var freewordBackgroundColor: Color {
        return Color(uiColor: UIColor(code: "#e7e7e7"))
    }

    private var glassIconColor: Color {
        return Color.gray
    }

    private var textFieldTextColor: Color {
        return Color.primary
    }

    private var cancelButtonTintColor: Color {
        return Color.gray
    }

    // フリーワード検索用のTextFieldと連動する
    // 👉 この値が変化すると配置元のView要素の @State と連動して処理が実行される
    @Binding var inputText: String

    // テキスト編集モードの判定フラグ
    // 👉 キャンセルボタン表示やキーボード状態のハンドリングで利用する
    @State private var isEditing = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0.0) {
            HStack {
                Text("フリーワード検索:")
                    .font(freewordTitleFont)
                    .foregroundColor(freewordTitleColor)
                    .padding([.top, .bottom], 8.0)
                Spacer()
            }
            .padding([.leading, .trailing], 12.0)
            // MEMO: ベースをZStackで作っているのはデザイン調整のため
            ZStack(alignment: .leading) {
                freewordBackgroundColor
                    .frame(width: 270.0)
                    .frame(height: 36.0)
                    .cornerRadius(8.0)
                // 検索バーに関連する部分
                HStack {
                    // (1) 虫眼鏡アイコン表示
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(glassIconColor)
                        .padding([.leading], 8.0)
                    // (2) 入力用テキストフィールド表示
                    TextField("Search", text: $inputText)
                        .padding(7.0)
                        .padding(.leading, -8.0)
                        .background(freewordBackgroundColor)
                        .cornerRadius(8.0)
                        // MEMO: Cursorの配色を変更する際には.accentColorを利用する
                        .accentColor(textFieldTextColor)
                        .foregroundColor(textFieldTextColor)
                        .onTapGesture(perform: {
                            // 👉 TextFieldがタップされると入力モードに変化し、Viewの再レンダリングが実行されます
                            isEditing = true
                        })
                    // (3) キャンセルボタン表示（※入力モードの場合のみ）
                    showCancelButtonIfNeeded()
                }
            }
            .padding([.leading, .trailing], 12.0)
        }
    }
    
    // MARK: - Private Function

    // @ViewBuilderを利用してViewを出し分けています
    // 参考: https://yanamura.hatenablog.com/entry/2019/09/05/150849
    @ViewBuilder
    private func showCancelButtonIfNeeded() -> some View {
        // 入力モードの場合のみキャンセルボタンを表示する様な形にする
        // ※ UIKitのUITextFieldに近い形にする
        if isEditing {
            Button(action: {
                // inputTextを空にする＆入力モードをキャンセルする
                // 👉 このタイミングでは配置元のViewでも何らかの処理を行う
                // 例. テキストの入力に合わせてAPIリクエストが実行される
                inputText = ""
                isEditing = false
                // キーボードを閉じるための処理
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }, label: {
                Text("Cancel")
                    .foregroundColor(cancelButtonTintColor)
            })
            .padding([.leading], 4.0)
            .padding([.trailing], 8.0)
            .transition(.move(edge: .trailing))
        }
    }
}

// MARK: - Preview

struct ArchiveFreewordView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveFreewordView(inputText: .constant(""))
    }
}
