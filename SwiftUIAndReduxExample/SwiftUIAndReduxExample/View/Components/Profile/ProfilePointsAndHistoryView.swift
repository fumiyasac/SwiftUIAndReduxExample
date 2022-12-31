//
//  ProfilePointsAndHistoryView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/31.
//

import SwiftUI

// TODO: ポイント履歴画面の作成
struct ProfilePointsAndHistoryView: View {

    // MARK: - Property

    private let nutrients: [String] = ["Energy", "Sugar", "Fat", "Protein", "Vitamins", "Minerals"]

    // MARK: - Initializer

    init() {}

    // MARK: - Body

    var body: some View {
        GroupBox {
            DisclosureGroup("Nutritional value per 100g") {
                ForEach(0..<nutrients.count, id: \.self) { item in
                    Divider().padding(.vertical, 2)
              
                    HStack {
                        Group {
                            Image(systemName: "info.circle")
                            Text(nutrients[item])
                        }
                        //.foregroundColor(fruit.gradientColors[1])
                        .font(Font.system(.body).bold())
                
                        Spacer(minLength: 25)
                
                        Text("あああ")
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .font(Font.system(.body).bold())
            .accentColor(Color.orange)
        }
        .padding([.leading, .trailing], 8.0)
    }
}

// MARK: - Preview

struct ProfilePointsAndHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePointsAndHistoryView()
    }
}
