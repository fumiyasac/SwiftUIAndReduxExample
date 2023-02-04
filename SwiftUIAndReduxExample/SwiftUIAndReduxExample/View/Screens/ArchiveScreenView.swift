//
//  ArchiveScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI

struct ArchiveScreenView: View {

    // MARK: - Redux

    @EnvironmentObject var store: Store<AppState>

    private struct Props {
        // Immutableに扱うProperty 👉 画面状態管理用
        let isLoading: Bool
        let isError: Bool
        let inputText: String
        let selectedCategory: String
        // Immutableに扱うProperty 👉 画面表示要素用
        let archiveCellViewObjects: [ArchiveCellViewObject]
        // Action発行用のClosure
        let requestArchiveWithSelecedCategory: (String) -> Void
        let requestArchiveWithInputText: (String) -> Void
        let requestArchiveWithNoConditions: () -> Void
        let addToDatabase: (ArchiveCellViewObject) -> Void
        let removeFromDatabase: (ArchiveCellViewObject) -> Void
        let requestArchive: () -> Void
        let retryArchive: () -> Void
    }

    private func mapStateToProps(state: ArchiveState) -> Props {
        Props(
            isLoading: state.isLoading,
            isError: state.isError,
            inputText: state.inputText,
            selectedCategory: state.selectedCategory,
            archiveCellViewObjects: state.archiveCellViewObjects,
            requestArchiveWithSelecedCategory: { selectedCategory in
                store.dispatch(action: RequestArchiveWithSelectedCategoryAction(selectedCategory: selectedCategory))
            },
            requestArchiveWithInputText: { inputText in
                store.dispatch(action: RequestArchiveWithInputTextAction(inputText: inputText))
            },
            requestArchiveWithNoConditions: {
                store.dispatch(action: RequestArchiveWithNoConditionsAction())
            },
            addToDatabase: { archiveCellViewObject in
                store.dispatch(action: AddArchiveObjectAction(archiveCellViewObject: archiveCellViewObject))
            },
            removeFromDatabase: { archiveCellViewObject in
                store.dispatch(action: DeleteArchiveObjectAction(archiveCellViewObject: archiveCellViewObject))
            },
            requestArchive: {
                store.dispatch(action: RequestArchiveWithNoConditionsAction())
            },
            retryArchive: {
                store.dispatch(action: RequestArchiveWithNoConditionsAction())
            }
        )
    }

    // MARK: - Body

    var body: some View {
        // 該当画面で利用するState(ここではArchiveState)をこの画面用のPropsにマッピングする
        let props = mapStateToProps(state: store.state.archiveState)

        // 表示に必要な値をPropsから取得する
        let isLoading = mapToIsLoading(props: props)
        let isError = mapToIsError(props: props)

        // 画面用のPropsに応じた画面要素表示処理を実行する
        NavigationStack {
            VStack(spacing: 0.0) {
                // (1) 検索機能部分
                Group {
                    showArchiveFreewordView(props: props)
                    showArchiveCategoryView(props: props)
                    showArchiveCurrentCountView(props: props)
                }
                // (2) 一覧データ表示部分
                Group {
                    if isLoading {
                        // ローディング画面を表示
                        ExecutingConnectionView()
                    } else if isError {
                        // エラー画面を表示
                        ConnectionErrorView(tapButtonAction: props.retryArchive)
                    } else {
                        // ArchiveContentsViewを表示
                        showArchiveContentsView(props: props)
                    }
                }
            }
            .navigationTitle("Archive")
            .navigationBarTitleDisplayMode(.inline)
            // 画面が表示された際に一度だけAPIリクエストを実行する形にしています。
            .onFirstAppear(props.requestArchive)
        }
    }
    
    // MARK: - Private Function

    @ViewBuilder
    private func showArchiveFreewordView(props: Props) -> some View {
        let isLoading = mapToIsLoading(props: props)
        let inputText = mapToInputText(props: props)
        ArchiveFreewordView(
            inputText: inputText,
            isLoading: isLoading,
            submitAction: { text in
                props.requestArchiveWithInputText(text)
            },
            cancelAction: {
                props.requestArchiveWithInputText("")
            }
        )
        // 👉 ここはクリアボタン押下時にTextFieldの中身をリセットしたいが為にやむなくこの形にしています...😢
        // 参考: https://swiftui-lab.com/swiftui-id/
        .id(UUID())
    }

    @ViewBuilder
    private func showArchiveCategoryView(props: Props) -> some View {
        let selectedCategory = mapToSelectedCategory(props: props)
        ArchiveCategoryView(
            selectedCategory: selectedCategory,
            tapCategoryChipAction: { category in
                props.requestArchiveWithSelecedCategory(category)
            }
        )
    }

    @ViewBuilder
    private func showArchiveCurrentCountView(props: Props) -> some View {
        let currentCount = mapToCurrentCount(props: props)
        ArchiveCurrentCountView(
            currentCount: currentCount,
            tapAllClearAction: {
                props.requestArchiveWithNoConditions()
                // 👉 キーボードを閉じるための処理（リセットボタンを押す際には全ての条件検索キャンセルされたとみなす）
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        )
    }

    @ViewBuilder
    private func showArchiveContentsView(props: Props) -> some View {
        // Propsから表示用のViewObjectを取り出す
        let archiveCellViewObjects = mapToArchiveCellViewObjects(props: props)
        let targetKeyword = mapToInputText(props: props)
        let targetCategory = mapToSelectedCategory(props: props)
        let currentCount = mapToCurrentCount(props: props)

        if currentCount == 0 {
            ArchiveEmptyView()
        } else {
            ArchiveContentsView(
                archiveCellViewObjects: archiveCellViewObjects,
                targetKeyword: targetKeyword,
                targetCategory: targetCategory,
                tapIsStoredButtonAction: { viewObject, isStored in
                    if isStored {
                        props.addToDatabase(viewObject)
                    } else {
                        props.removeFromDatabase(viewObject)
                    }
                }
            )
        }
    }

    private func mapToCurrentCount(props: Props) -> Int {
        return props.archiveCellViewObjects.count
    }

    private func mapToArchiveCellViewObjects(props: Props) -> [ArchiveCellViewObject] {
        return props.archiveCellViewObjects
    }

    private func mapToSelectedCategory(props: Props) -> String {
        return props.selectedCategory
    }

    private func mapToInputText(props: Props) -> String {
        return props.inputText
    }

    private func mapToIsError(props: Props) -> Bool {
        return props.isError
    }

    private func mapToIsLoading(props: Props) -> Bool {
        return props.isLoading
    }
}

// MARK: - Preview

struct ArchiveScreenView_Previews: PreviewProvider {
    static var previews: some View {
        // Success時の画面表示
        let archiveSuccessStore = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                archiveMockSuccessMiddleware(),
                addMockArchiveObjectMiddleware(),
                deleteMockArchiveObjectMiddleware()
            ]
        )
        ArchiveScreenView()
            .environmentObject(archiveSuccessStore)
            .previewDisplayName("Archive Secreen Success Preview")
        // Failure時の画面表示
        let archiveFailureStore = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                archiveMockFailureMiddleware(),
                addMockArchiveObjectMiddleware(),
                deleteMockArchiveObjectMiddleware()
            ]
        )
        ArchiveScreenView()
            .environmentObject(archiveFailureStore)
            .previewDisplayName("Archive Secreen Failure Preview")
    }
}
