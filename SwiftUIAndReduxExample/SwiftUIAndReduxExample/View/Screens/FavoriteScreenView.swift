//
//  FavoriteScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI

struct FavoriteScreenView: View {

    // MARK: - body

    var body: some View {
        NavigationView {
            Text("FavoriteScreenView")
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
