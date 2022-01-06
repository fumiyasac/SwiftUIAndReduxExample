//
//  SwiftUIColorExtension.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/01/06.
//

import SwiftUI

// MEMO: 下記Stackoverflowの内容を参照
// https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui
extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
