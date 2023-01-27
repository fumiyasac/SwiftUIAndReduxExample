//
//  ProfileScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI

struct ProfileScreenView: View {

    // MARK: - body

    var body: some View {
        NavigationStack {
            Group {
                ProfileContentsView()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            // 👉 SafeAreaまで表示領域を伸ばす（これをするとサムネイル画像が綺麗に収まる）
            .edgesIgnoringSafeArea(.top)
            // 👉 NavigationBarを隠すか否か際の設定
            // ※ GeometryReaderを用いたParallax表現時には、NavigationBarで上部が隠れてしまうため、この様な形としています。
            .navigationBarHidden(true)
            // Debug. APIとの疎通確認（※後程削除する）
            .onFirstAppear {
                Task {
                    do {
                        let result = try await ProfileRepositoryFactory.create().getProfileResponses()
                        print("成功")
                        dump(result)
                    } catch APIError.error(let message) {
                        print("失敗")
                        print(message)
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct ProfileScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreenView()
    }
}
