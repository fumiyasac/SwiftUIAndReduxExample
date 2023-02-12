//
//  ArchiveFreewordView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/04.
//

import SwiftUI

struct ArchiveFreewordView: View {

    // MARK: - Typealias

    typealias SubmitAction = (String) -> Void
    typealias CancelAction = () -> Void

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

    private var textFieldTextFont: Font {
        return Font.custom("AvenirNext-Regular", size: 14)
    }

    private var textFieldTextColor: Color {
        return Color.primary
    }

    private var cancelButtonTintColor: Color {
        return Color.gray
    }

    // フリーワード検索用のTextFieldと連動する変数
    @State private var currentInputText: String
    // テキスト編集モードの判定フラグ変数
    @State private var isEditing: Bool

    private let isLoading: Bool
    private let submitAction: ArchiveFreewordView.SubmitAction
    private let cancelAction: ArchiveFreewordView.CancelAction

    // MARK: - Initializer

    init(
        inputText: String,
        isLoading: Bool,
        submitAction: @escaping ArchiveFreewordView.SubmitAction,
        cancelAction: @escaping ArchiveFreewordView.CancelAction
    ) {
        self.isLoading = isLoading
        self.submitAction = submitAction
        self.cancelAction = cancelAction

        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        _currentInputText = State(initialValue: inputText)
        _isEditing = State(initialValue: false)
    }

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
                    .frame(width: 270.0, height: 36.0)
                    .cornerRadius(8.0)
                // 検索バーに関連する部分
                HStack {
                    // (1) 虫眼鏡アイコンまたはインジケーター表示
                    showLoadingIndicatorIfNeeded()
                    // (2) 入力用テキストフィールド表示
                    TextField("キーワードを入力して下さい", text: $currentInputText)
                        .padding(7.0)
                        .padding(.leading, -8.0)
                        .font(textFieldTextFont)
                        .background(freewordBackgroundColor)
                        .cornerRadius(8.0)
                        // MEMO: Cursorの配色を変更する際には.accentColorを利用する
                        .accentColor(textFieldTextColor)
                        .foregroundColor(textFieldTextColor)
                        .onTapGesture(perform: {
                            // 👉 TextFieldがタップされると入力モードに変化し、Viewの再レンダリングが実行されます
                            isEditing = true
                        })
                        .onSubmit({
                            // 👉 Submit（キーボードの確定またはreturnボタンを押下時の処理）を親のView要素へ伝える
                            isEditing = false
                            submitAction(currentInputText)
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
    private func showLoadingIndicatorIfNeeded() -> some View {
        if isLoading {
            LoadingIndicatorViewRepresentable(isLoading: .constant(true))
                .frame(width: 24.0, height: 24.0)
                .padding([.leading], 4.0)
        } else {
            Image(systemName: "magnifyingglass")
                .foregroundColor(glassIconColor)
                .padding([.leading], 8.0)
        }
    }

    @ViewBuilder
    private func showCancelButtonIfNeeded() -> some View {
        // 入力モードの場合のみキャンセルボタンを表示する様な形にする
        // ※ UIKitのUITextFieldに近い形にする
        if isEditing {
            Button(action: {
                // inputTextを空にする＆入力モードをキャンセルする
                // 👉 このタイミングでは配置元のViewでも何らかの処理を行う
                // 例. テキストの入力に合わせてAPIリクエストが実行される
                currentInputText = ""
                isEditing = false
                // 👉 キャンセルを親のView要素へ伝える
                cancelAction()
                // 👉 キーボードを閉じるための処理
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
        ArchiveFreewordView(inputText: "", isLoading: false, submitAction: { _ in }, cancelAction: {})
            .previewDisplayName("ArchiveFreewordView (Default) Preview")
        ArchiveFreewordView(inputText: "韓国料理", isLoading: false, submitAction: { _ in }, cancelAction: {})
            .previewDisplayName("ArchiveFreewordView (Exist Keyword) Preview")
        ArchiveFreewordView(inputText: "ベトナム", isLoading: true, submitAction: { _ in }, cancelAction: {})
            .previewDisplayName("ArchiveFreewordView (Loading) Preview")
    }
}
