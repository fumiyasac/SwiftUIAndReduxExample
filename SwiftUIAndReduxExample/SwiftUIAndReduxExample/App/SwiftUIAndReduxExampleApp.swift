//
//  SwiftUIAndReduxExampleApp.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/09/08.
//

import SwiftUI

@main
struct SwiftUIAndReduxExampleApp: App {

    // MEMO: AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // MARK: - body

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
