//
//  ContentView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/09/08.
//

import SwiftUI

struct ContentView: View {

    // MARK: - EnvironmentObject

    // 👉 画面全体用のView要素についても同様に.environmentObjectを利用してstoreを適用する
    @EnvironmentObject var store: Store<AppState>

    private struct Props {
        // Immutableに扱うProperty 👉 画面状態管理用
        let showOnboarding: Bool
        // Action発行用のClosure
        let requestOnboarding: () -> Void
        let closeOnboarding: () -> Void
    }

    private func mapStateToProps(state: OnboardingState) -> Props {
        Props(
            showOnboarding: state.showOnboarding,
            requestOnboarding: {
                store.dispatch(action: RequestOnboardingAction())
            },
            closeOnboarding: {
                store.dispatch(action: CloseOnboardingAction())
            }
        )
    }

    // MARK: - Body

    var body: some View {
        // 該当画面で利用するState(ここではOnboardingState)をこの画面用のPropsにマッピングする
        let props = mapStateToProps(state: store.state.onboardingState)

        // 表示に必要な値をPropsから取得する
        let onboardingState = mapToshowOnboarding(props: props)

        // 画面用のPropsに応じた画面要素表示処理を実行する
        ZStack {
            // (1) TabView表示要素の配置
            TabView {
                HomeScreenView()
                    .environmentObject(store)
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    }
                    .tag(0)
                ArchiveScreenView()
                    .environmentObject(store)
                    .tabItem {
                        VStack {
                            Image(systemName: "archivebox.fill")
                            Text("Archive")
                        }
                    }.tag(1)
                FavoriteScreenView()
                    .environmentObject(store)
                    .tabItem {
                        VStack {
                            Image(systemName: "bookmark.square.fill")
                            Text("Favorite")
                        }
                    }.tag(2)
                ProfileScreenView()
                    .environmentObject(store)
                    .tabItem {
                        VStack {
                            Image(systemName: "person.crop.circle.fill")
                            Text("Profile")
                        }
                    }.tag(3)
            }
            .accentColor(Color(uiColor: UIColor(code: "#b9d9c3")))
            // (2) 初回起動ダイアログ表示要素の配置
            if onboardingState {
                withAnimation(.linear(duration: 0.3)) {
                    Group {
                        Color.black.opacity(0.64)
                        OnboardingContentsView(closeOnboardingAction: props.closeOnboarding)
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        }
        .onFirstAppear(props.requestOnboarding)
    }

    // MARK: - Private Function

    private func mapToshowOnboarding(props: Props) -> Bool {
        return props.showOnboarding
    }
}

// MARK: - Preview

#Preview("ContentView Preview") {
    let store = Store(
        reducer: appReducer,
        state: AppState(),
        middlewares: [
            // 👉 Preview表示確認用にMockを適用しています
            // OnBoarding
            // ※ onBoardingを表示しない場合
            //onboardingMockHideMiddleware(),
            onboardingMockShowMiddleware(),
            onboardingMockCloseMiddleware(),
            // Home
            homeMockSuccessMiddleware(),
            // Archive
            archiveMockSuccessMiddleware(),
            addMockArchiveObjectMiddleware(),
            deleteMockArchiveObjectMiddleware(),
            // Favorite
            favoriteMockSuccessMiddleware(),
            // Profile
            profileMockSuccessMiddleware()
        ]
    )
    return ContentView()
        .environmentObject(store)
}
