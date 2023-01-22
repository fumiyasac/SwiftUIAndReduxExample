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
