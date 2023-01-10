//
//  LoadingIndicatorViewRepresentable.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/10.
//

import SwiftUI
import UIKit

struct LoadingIndicatorViewRepresentable: UIViewRepresentable {
    
    // MARK: - Property
    
    let style: UIActivityIndicatorView.Style
    
    @Binding var isLoading: Bool
    
    // MARK: - Function
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {

        // このインジケータ表示に関する初期設定
        uiView.style = .medium
        uiView.hidesWhenStopped = true
        
        // @Bindingで設定された読み込み中か否かの状態を反映する
        if isLoading {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
        
        // 内在サイズに則って自動でCosmosViewをリサイズする
        // 参考: 内在サイズについての説明
        // https://developer.mozilla.org/ja/docs/Glossary/Intrinsic_Size
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}
