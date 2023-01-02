//
//  ProfileInformationView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/01.
//

import SwiftUI

struct ProfileInformationView: View {

    // MARK: - Property

    

    // MARK: - Initializer

    init() {}
    
    // MARK: - Body

    var body: some View {
        ProfileInformationTabSwitcher()
            .padding([.bottom], 24.0)
    }
}

// MARK: - Preview

struct ProfileInformationView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInformationView()
    }
}
