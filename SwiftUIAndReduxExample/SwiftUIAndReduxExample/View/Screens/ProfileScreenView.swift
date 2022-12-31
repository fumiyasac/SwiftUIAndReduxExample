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
            ProfileContentsView()
                .navigationBarTitle(Text("Profile"), displayMode: .inline)
                // 👉 NavigationBarを隠すか否か際の設定
                // ※ GeometryReaderを用いたParallax表現時には、NavigationBarで上部が隠れてしまうため、この様な形としています。
                .navigationBarHidden(true)
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
