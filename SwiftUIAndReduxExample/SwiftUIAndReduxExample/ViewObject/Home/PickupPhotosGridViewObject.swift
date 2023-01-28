//
//  PickupPhotosGridViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

// MARK: - ViewObject

struct PickupPhotosGridViewObject: Identifiable {
    let id: Int
    let title: String
    let caption: String
    let photoUrl: URL?
    let photoWidth: CGFloat
    let photoHeight: CGFloat
}
