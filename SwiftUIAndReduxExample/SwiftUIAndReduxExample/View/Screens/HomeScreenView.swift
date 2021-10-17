//
//  HomeScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI

struct HomeScreenView: View {

    // MARK: - body

    var body: some View {
        NavigationView {
            Text("HomeScreenView")
                .navigationBarTitle(Text("Home"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Preview

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
