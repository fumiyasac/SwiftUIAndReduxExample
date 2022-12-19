//
//  FavoriteSwipePagingView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/14.
//

import SwiftUI
import CollectionViewPagingLayout

struct FavoriteSwipePagingView: View {

    struct Item: Identifiable {
        let id: UUID = .init()
        let number: Int
    }

    let items = Array(0..<10).map {
        Item(number: $0)
    }

    var body: some View {
        StackPageView(items) { item in
            ZStack {
                Rectangle().fill(Color.orange)
                Text("\(item.number)")
            }
            .frame(
                width: (UIScreen.main.bounds.width - 72.0),
                height: (UIScreen.main.bounds.width - 72.0) * 1120 / 840
            )
            .cornerRadius(8.0)
        }
        //
        .onTapPage({ id in
            print(id)
        })
        .pagePadding(
            vertical: .absolute(60),
            horizontal: .absolute(60)
        )
    }
}

struct FavoriteSwipePagingView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteSwipePagingView()
    }
}
