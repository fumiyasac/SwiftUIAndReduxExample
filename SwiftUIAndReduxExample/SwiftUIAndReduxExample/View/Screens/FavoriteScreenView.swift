//
//  FavoriteScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI
import CollectionViewPagingLayout

struct FavoriteScreenView: View {

    // Replace with your data
    struct Item: Identifiable {
        let id: UUID = .init()
        let number: Int
    }
    let items = Array(0..<10).map {
        Item(number: $0)
    }
    
    // MARK: - body

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HomeCommonSectionView(title: "季節の特集コンテンツ一覧", subTitle: "Introduce seasonal shopping and features.")
                .background(.red)
                .frame(height: 66.0)
                .frame(maxWidth: .infinity)
//                VStack {
//                    Text("aaaaa")
//                    Spacer()
//                }
                .background(.red)
                .frame(height: 66.0)
                .frame(maxWidth: .infinity)
                StackPageView(items) { item in
                    // Build your view here
                    ZStack {
                        Rectangle().fill(Color.orange)
                        Text("\(item.number)")
                    }
                    .frame(
                        width: (UIScreen.main.bounds.width - 64.0),
                        height: (UIScreen.main.bounds.width - 64.0) * 1120 / 840
                    )
                }
                //.options(options)
                // The padding around each page
                // you can use `.fractionalWidth` and
                // `.fractionalHeight` too
                .pagePadding(
                    vertical: .absolute(60),
                    horizontal: .absolute(60)
                )
            }
            .navigationBarTitle(Text("Favorite"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Preview

struct FavoriteScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteScreenView()
    }
}
