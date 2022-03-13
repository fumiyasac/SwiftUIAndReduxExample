//
//  ContentView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/09/08.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Propety

    private let contentRouter = ContentRouter()

    // MARK: - body

    var body: some View {
        // MEMO: Routerを介して画面を表示させる形にする
        // → ContentViewを起点とする場合にはContentRouterクラスを定義し、その中に実際の画面生成処理を書く方針としています。
        TabView {
            contentRouter.routeToHome()
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
                .tag(0)
            contentRouter.routeToArchive()
                .tabItem {
                    VStack {
                        Image(systemName: "archivebox.fill")
                        Text("Archive")
                    }
                }.tag(1)
            contentRouter.routeToFavorite()
                .tabItem {
                    VStack {
                        Image(systemName: "bookmark.square.fill")
                        Text("Favorite")
                    }
                }.tag(2)
            contentRouter.routeToProfile()
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
//        ContentView()
//    }
//}
