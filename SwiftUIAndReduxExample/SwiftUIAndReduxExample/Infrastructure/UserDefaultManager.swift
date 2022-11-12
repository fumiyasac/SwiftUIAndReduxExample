//
//  UserDefaultManager.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/12.
//

import Foundation
import SwiftyUserDefaults

// MEMO: ライブラリ「SwiftyUserDefaults」を利用する形
// 補足: Quick/Nimbleを用いたテストコードで書きやすい点やPropertyWrapperにも標準で対応している

extension DefaultsKeys {

    // MARK: - Property

    // MEMO: 下記の様なイメージでUserDefault値を定義する（こちらはは初回起動のフラグ値を持つ場合の例）
    // 補足1: 一時的なフラグ値や条件分岐の設定等の場合に用いる
    // 補足2: 設定する値についてはDictionaryやEnumも利用可能
    // 補足3: Xcode14以降では下記のワークアラウンドは不要
    // https://github.com/sunshinejr/SwiftyUserDefaults/issues/285#issuecomment-1066897689

    var isInitialBoot: DefaultsKey<Bool> {
        .init("isInitialBoot", defaultValue: false)
    }
}
