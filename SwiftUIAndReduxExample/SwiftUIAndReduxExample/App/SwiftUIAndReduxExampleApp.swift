//
//  SwiftUIAndReduxExampleApp.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/09/08.
//

import SwiftUI
import UIKit

@main
struct SwiftUIAndReduxExampleApp: App {

    // MARK: - Initialzer

    init() {
        setupNavigationAppearnces()
    }

    // MARK: - body

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    // MARK: - Private Function

    private func setupNavigationAppearnces() {

        // MEMO: NavigationBarの色を白色に合わせる対応
        let newNavAppearance = UINavigationBarAppearance()
        newNavAppearance.configureWithTransparentBackground()
        newNavAppearance.backgroundColor = AppConstants.ColorPalette.primary
        UINavigationBar.appearance().standardAppearance = newNavAppearance
    }
}
