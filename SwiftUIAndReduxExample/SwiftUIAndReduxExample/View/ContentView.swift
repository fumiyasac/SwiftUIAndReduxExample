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

    // MARK: - Body

    var body: some View {
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
            .accentColor(Color(AppConstants.ColorPalette.mint))
            // (2) 初回起動ダイアログ表示要素の配置
            // TODO: この部分もContentView用のRedux処理を利用してハンドリングができる様にする
            if true {
                Group {
                    Color.black.opacity(0.64)
                    OnboardingContentsView(closeOnboardingAction: {
                        
                    })
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

// MARK: - Preview

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let store = Store(
//            reducer: appReducer,
//            state: AppState(),
//            middlewares: []
//        )
//        ContentView()
//            .environmentObject(store)
//    }
//}
