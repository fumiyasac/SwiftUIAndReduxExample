//
//  StringExtension.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/02.
//

import Foundation
import UIKit

extension String {

    // MEMO: 設定されたUIFontの値から幅を取得する（※Tab型切り替えMenu画面等で活用する）
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
