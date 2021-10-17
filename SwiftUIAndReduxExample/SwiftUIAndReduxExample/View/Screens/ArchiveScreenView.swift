//
//  ArchiveScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI

struct ArchiveScreenView: View {

    // MARK: - body

    var body: some View {
        NavigationView {
            Text("ArchiveScreenView")
                .navigationBarTitle(Text("Archive"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Preview

struct ArchiveScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveScreenView()
    }
}
