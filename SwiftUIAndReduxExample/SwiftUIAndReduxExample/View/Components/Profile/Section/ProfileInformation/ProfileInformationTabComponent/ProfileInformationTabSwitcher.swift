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
        return Color(uiColor: UIColor(code: "#b9d9c3"))
    }

    private let profileInformationViewObject: ProfileInformationViewObject

    // 👉 有効にしたいTab要素を格納するための設けている
    private let profileInformationTabs: [ProfileInformationTab]

    // 👉 現在のTab位置を保持するためのState値
    @State private var currentProfileInformationTab: ProfileInformationTab

    // MARK: - Initializer

    init(profileInformationViewObject: ProfileInformationViewObject) {
        self.profileInformationViewObject = profileInformationViewObject

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
                ProfileInformationAnnouncementView(
                    profileAnnoucementViewObjects: profileInformationViewObject.profileAnnoucementViewObjects
                )
            case .comment:
                ProfileInformationCommentView(
                    profileCommentViewObjects: profileInformationViewObject.profileCommentViewObjects
                )
            case .recent:
                ProfileInformationRecentView(
                    profileRecentFavoriteViewObjects: profileInformationViewObject.profileRecentFavoriteViewObjects
                )
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

#Preview("ProfileInformationTabSwitcher Preview") {
    // MEMO: 部品1つあたりを表示するためのViewObject
    let profileAnnoucementViewObjects = getProfileAnnoucementResponse().result.map {
        ProfileAnnoucementViewObject(
            id: $0.id,
            category: $0.category,
            title: $0.title,
            publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt),
            description: $0.description
        )
    }
    let profileCommentViewObjects = getProfileCommentResponse().result.map {
        ProfileCommentViewObject(
            id: $0.id,
            emotion: $0.emotion,
            title: $0.title,
            publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt),
            comment: $0.comment
        )
    }
    let profileRecentFavoriteViewObjects = getProfileRecentFavoriteResponse().result.map {
        ProfileRecentFavoriteViewObject(
            id: $0.id,
            category: $0.category,
            title: $0.title,
            publishedAt: DateLabelFormatter.getDateStringFromAPI(apiDateString: $0.publishedAt),
            description: $0.description
        )
    }
    let profileInformationViewObject = ProfileInformationViewObject(
        id: 100,
        profileAnnoucementViewObjects: profileAnnoucementViewObjects,
        profileCommentViewObjects: profileCommentViewObjects,
        profileRecentFavoriteViewObjects: profileRecentFavoriteViewObjects
    )
    // Preview: ProfileInformationTabSwitcher
    return ProfileInformationTabSwitcher(profileInformationViewObject: profileInformationViewObject)

    // MARK: - Function

    func getProfileAnnoucementResponse() -> ProfileAnnoucementResponse {
        guard let path = Bundle.main.path(forResource: "profile_announcement", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ProfileAnnoucementEntity].self, from: data) else {
            fatalError()
        }
        return ProfileAnnoucementResponse(result: result)
    }

    func getProfileCommentResponse() -> ProfileCommentResponse {
        guard let path = Bundle.main.path(forResource: "profile_comment", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ProfileCommentEntity].self, from: data) else {
            fatalError()
        }
        return ProfileCommentResponse(result: result)
    }

    func getProfileRecentFavoriteResponse() -> ProfileRecentFavoriteResponse {
        guard let path = Bundle.main.path(forResource: "profile_recent_favorite", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ProfileRecentFavoriteEntity].self, from: data) else {
            fatalError()
        }
        return ProfileRecentFavoriteResponse(result: result)
    }
}
