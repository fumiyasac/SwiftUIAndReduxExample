//
//  ArchiveSearchView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/29.
//

import SwiftUI

struct ArchiveSearchView: View {

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            // (1) 検索機能部分
            Group {
                ArchiveFreewordView(inputText: .constant(""))
                ArchiveCategoryView(selectedCategory: .constant("Category1"))
            }
            // (2) 一覧データ表示部分
            ScrollView {
                
            }
        }
    }
}

// MARK: - Preview

struct ArchiveSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveSearchView()
    }
}
