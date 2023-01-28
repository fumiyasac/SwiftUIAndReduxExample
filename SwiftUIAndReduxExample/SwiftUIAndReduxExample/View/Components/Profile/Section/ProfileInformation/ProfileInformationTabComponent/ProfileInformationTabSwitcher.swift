//
//  ProfileInformationTabSwitcher.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/02.
//

import SwiftUI

// MARK: - Enum

enum ProfileInformationTab: String, CaseIterable {
    case announcement = "Announcement from App"
    case comment = "Comment for You"
    case recent = "Recent for Favorite Shop"
}

struct ProfileInformationTabSwitcher: View {
    
    // MARK: - Property
    
    private var tabNameFont: Font {
        return Font.custom("AvenirNext-Bold", size: 14)
    }

    private var tabRectangleColor: Color {
        return Color(uiColor: AppConstants.ColorPalette.mint)
    }

    private var profileInformationTabs: [ProfileInformationTab]
    
    @State private var currentProfileInformationTab: ProfileInformationTab

    // MARK: - Initializer
    
    init() {
        // Tab要素として表示したい全てのケースを設定するための変数
        profileInformationTabs = ProfileInformationTab.allCases
        
        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        _currentProfileInformationTab = State(initialValue: .announcement)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0.0) {
            // MEMO: 水平Scrollを利用したTab型切り替え表示部分
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20.0) {
                    ForEach(profileInformationTabs, id: \.self) { tab in
                        VStack {
                            // (1) 現在位置を指し示す上部バー部分
                            Rectangle()
                                .frame(
                                    width: getWidthForTabText(tab),
                                    height: 4.0
                                )
                                .foregroundColor(getForegroundColorForTabRectangle(tab))
                            // (2) Enum要素の文字を表示したButton部分
                            Button(action: {
                                // 👉 @Stateとして定義したcurrentProfileInformationTabの値を更新することで、このView要素を再レンダリングして表示を変更する
                                currentProfileInformationTab = tab
                            }, label: {
                                Text(tab.rawValue)
                                    .font(tabNameFont)
                                    .foregroundColor(getForegroundColorForTabText(tab))
                            })
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: getWidthForTabText(tab), height: 30.0)
                        }
                    }
                }
            }
            .padding([.bottom], 8.0)
            // MEMO: 定義したEnum要素に対応した画面要素表示
            switch currentProfileInformationTab {
            case .announcement:
                ProfileInformationAnnouncementView()
            case .comment:
                ProfileInformationCommentView()
            case .recent:
                ProfileInformationRecentView()
            }
        }
    }

    // MARK: - Private Function
    
    private func getForegroundColorForTabRectangle(_ tab: ProfileInformationTab) -> Color {
        if tab == currentProfileInformationTab {
            return tabRectangleColor
        } else {
            return .clear
        }
    }

    private func getForegroundColorForTabText(_ tab: ProfileInformationTab) -> Color {
        if tab == currentProfileInformationTab {
            return tabRectangleColor
        } else {
            return .gray
        }
    }

    private func getWidthForTabText(_ tab: ProfileInformationTab) -> CGFloat {
        let string = tab.rawValue
        return string.widthOfString(usingFont: UIFont(name: "AvenirNext-Bold", size: 14)!)
    }
}

// MARK: - Preview

struct ProfileInformationTabSwitcher_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInformationTabSwitcher()
    }
}
