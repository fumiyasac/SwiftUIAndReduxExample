//
//  ApplicationStatusLocalStore.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/13.
//

import Foundation
import SwiftyUserDefaults

// MARK: - Struct

struct ApplicationStatusLocalStore {
    @SwiftyUserDefault(keyPath: \.isInitialBoot)
    var isInitialBoot: Bool
}
