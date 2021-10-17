//
//  ProfileScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI

struct ProfileScreenView: View {

    // MARK: - body

    var body: some View {
        NavigationView {
            Text("ProfileScreenView")
                .navigationBarTitle(Text("Profile"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Preview

struct ProfileScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreenView()
    }
}
