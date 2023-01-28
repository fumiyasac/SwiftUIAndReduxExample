//
//  PickupPhotosGridViewObject.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/28.
//

import Foundation

// MARK: - ViewObject

struct PickupPhotosGridViewObject: Identifiable, Equatable {
    
    // MARK: - Property

    let id: Int
    let title: String
    let caption: String
    let photoUrl: URL?
    let photoWidth: CGFloat
    let photoHeight: CGFloat

    // MARK: - Equatable

    static func == (lhs: PickupPhotosGridViewObject, rhs: PickupPhotosGridViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}
