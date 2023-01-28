//
//  FavoriteScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI
import CollectionViewPagingLayout

struct FavoriteScreenView: View {

    // MARK: - Redux

    @EnvironmentObject var store: Store<AppState>

    private struct Props {
        // Immutableに扱うProperty 👉 画面状態管理用
        let isLoading: Bool
        let isError: Bool
        // Immutableに扱うProperty 👉 画面表示要素用
        let favoritePhotosCardViewObjects: [FavoritePhotosCardViewObject]
        // Action発行用のClosure
        let requestFavorite: () -> Void
        let retryFavorite: () -> Void
    }

    private func mapStateToProps(state: FavoriteState) -> Props {
        Props(
            isLoading: state.isLoading,
            isError: state.isError,
            favoritePhotosCardViewObjects: state.favoritePhotosCardViewObjects,
            requestFavorite: {
                store.dispatch(action: RequestFavoriteAction())
            },
            retryFavorite: {
                store.dispatch(action: RequestFavoriteAction())
            }
        )
    }

    // MARK: - Body

    var body: some View {
        // 該当画面で利用するState(ここではHomeState)をこの画面用のPropsにマッピングする
        let props = mapStateToProps(state: store.state.favoriteState)
        // 画面用のPropsに応じた画面要素表示処理を実行する
        NavigationStack {
            Group {
                if props.isLoading {
                    // ローディング画面を表示
                    ExecutingConnectionView()
                } else if props.isError {
                    // エラー画面を表示
                    ConnectionErrorView(tapButtonAction: props.retryFavorite)
                } else {
                    // Favorite画面を表示
                    showFavoriteScreen(props: props)
                }
            }
            .navigationTitle("Favorite")
            .navigationBarTitleDisplayMode(.inline)
            // 画面が表示された際に一度だけAPIリクエストを実行する形にしています。
            .onFirstAppear(props.requestFavorite)
        }
    }

    // MARK: - Private Function

    @ViewBuilder
    private func showFavoriteScreen(props: Props) -> some View {
        // Propsの値を表示用のViewObjectにマッピングし直す
        let favoritePhotosCardViewObjects = mapToFavoritePhotosCardViewObjects(props: props)
        // 該当するView要素に表示に必要なViewObjectを反映する
        VStack(spacing: 0) {
            FavoriteCommonSectionView()
            FavoriteSwipePagingView(favoritePhotosCardViewObjects: favoritePhotosCardViewObjects)
        }
    }

    private func mapToFavoritePhotosCardViewObjects(props: Props) -> [FavoritePhotosCardViewObject] {
        return props.favoritePhotosCardViewObjects
    }
}

// MARK: - Preview

struct FavoriteScreenView_Previews: PreviewProvider {
    static var previews: some View {
        // Success時の画面表示
        let favoriteSuccessStore = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                favoriteMockSuccessMiddleware()
            ]
        )
        FavoriteScreenView()
            .environmentObject(favoriteSuccessStore)
            .previewDisplayName("Favorite Secreen Success Preview")
        // Failure時の画面表示
        let favoriteFailureStore = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                favoriteMockFailureMiddleware()
            ]
        )
        FavoriteScreenView()
            .environmentObject(favoriteFailureStore)
            .previewDisplayName("Favorite Secreen Failure Preview")
    }
}
