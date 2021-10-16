//
//  ContentView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/09/08.
//

import SwiftUI

struct ContentView: View {

    // MARK: - body

    var body: some View {
        TabView {
            HomeScreenView()
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
                .tag(0)
            ArchiveScreenView()
                .tabItem {
                    VStack {
                        Image(systemName: "archivebox.fill")
                        Text("Archive")
                    }
                }.tag(1)
            FavoriteScreenView()
                .tabItem {
                    VStack {
                        Image(systemName: "bookmark.square.fill")
                        Text("Favorite")
                    }
                }.tag(2)
            ProfileScreenView()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
