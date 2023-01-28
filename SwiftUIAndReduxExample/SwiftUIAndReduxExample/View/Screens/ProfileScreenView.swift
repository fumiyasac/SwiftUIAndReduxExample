//
//  ProfileScreenView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2021/10/16.
//

import SwiftUI

struct ProfileScreenView: View {

    // MARK: - Redux

    @EnvironmentObject var store: Store<AppState>

    private struct Props {
        // Immutableに扱うProperty 👉 画面状態管理用
        let isLoading: Bool
        let isError: Bool
        // Immutableに扱うProperty 👉 画面表示要素用
        let backgroundImageUrl: String?
        let profilePersonalViewObject: ProfilePersonalViewObject?
        let profileSelfIntroductionViewObject: ProfileSelfIntroductionViewObject?
        let profilePointsAndHistoryViewObject: ProfilePointsAndHistoryViewObject?
        let profileSocialMediaViewObject: ProfileSocialMediaViewObject?
        let profileInformationViewObject: ProfileInformationViewObject?
        // Action発行用のClosure
        let requestProfile: () -> Void
        let retryProfile: () -> Void
    }

    private func mapStateToProps(state: ProfileState) -> Props {
        Props(
            isLoading: state.isLoading,
            isError: state.isError,
            backgroundImageUrl: state.backgroundImageUrl,
            profilePersonalViewObject: state.profilePersonalViewObject,
            profileSelfIntroductionViewObject: state.profileSelfIntroductionViewObject,
            profilePointsAndHistoryViewObject: state.profilePointsAndHistoryViewObject,
            profileSocialMediaViewObject: state.profileSocialMediaViewObject,
            profileInformationViewObject: state.profileInformationViewObject,
            requestProfile: {
                store.dispatch(action: RequestProfileAction())
            },
            retryProfile: {
                store.dispatch(action: RequestProfileAction())
            }
        )
    }

    // MARK: - body

    var body: some View {
        // 該当画面で利用するState(ここではHomeState)をこの画面用のPropsにマッピングする
        let props = mapStateToProps(state: store.state.profileState)
        // 画面用のPropsに応じた画面要素表示処理を実行する
        NavigationStack {
            Group {
                if props.isLoading {
                    // ローディング画面を表示
                    ExecutingConnectionView()
                } else if props.isError {
                    // エラー画面を表示
                    ConnectionErrorView(tapButtonAction: props.retryProfile)
                } else {
                    // ProfileContentsView(それぞれのSection要素を集約している画面要素)を表示
                    showProfileContentsView(props: props)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            // 👉 SafeAreaまで表示領域を伸ばす（これをするとサムネイル画像が綺麗に収まる）
            .edgesIgnoringSafeArea(.top)
            // 👉 NavigationBarを隠すか否か際の設定
            // ※ GeometryReaderを用いたParallax表現時には、NavigationBarで上部が隠れてしまうため、この様な形としています。
            .navigationBarHidden(true)
            // 画面が表示された際に一度だけAPIリクエストを実行する形にしています。
            .onFirstAppear(props.requestProfile)
        }
    }

    // MARK: - Private Function

    @ViewBuilder
    private func showProfileContentsView(props: Props) -> some View {
        // Propsから各表示用のViewObjectを取り出す
        if let backgroundImageUrl = mapToBackgroundImageUrl(props: props),
           let profilePersonalViewObject = mapToProfilePersonalViewObject(props: props),
           let profileSelfIntroductionViewObject = mapToProfileSelfIntroductionViewObject(props: props),
           let profilePointsAndHistoryViewObject = mapToProfilePointsAndHistoryViewObject(props: props),
           let profileSocialMediaViewObject = mapToProfileSocialMediaViewObject(props: props),
           let profileInformationViewObject = mapToProfileInformationViewObject(props: props) {
            // 表示に必要な要素がすべて揃っていた場合はProfileContentsViewを表示させる
            ProfileContentsView(
                backgroundImageUrl: backgroundImageUrl,
                profilePersonalViewObject: profilePersonalViewObject,
                profileSelfIntroductionViewObject: profileSelfIntroductionViewObject,
                profilePointsAndHistoryViewObject: profilePointsAndHistoryViewObject,
                profileSocialMediaViewObject: profileSocialMediaViewObject,
                profileInformationViewObject: profileInformationViewObject
            )
        } else {
            // 少なくとも1つnilになる物があった場合はEmptyViewを表示させる
            VStack {
                EmptyView()
            }
        }
    }

    private func mapToBackgroundImageUrl(props: Props) -> URL? {
        return URL(string: props.backgroundImageUrl ?? "")
    }

    private func mapToProfilePersonalViewObject(props: Props) -> ProfilePersonalViewObject? {
        return props.profilePersonalViewObject
    }

    private func mapToProfileSelfIntroductionViewObject(props: Props) -> ProfileSelfIntroductionViewObject? {
        return props.profileSelfIntroductionViewObject
    }

    private func mapToProfilePointsAndHistoryViewObject(props: Props) -> ProfilePointsAndHistoryViewObject? {
        return props.profilePointsAndHistoryViewObject
    }

    private func mapToProfileSocialMediaViewObject(props: Props) -> ProfileSocialMediaViewObject? {
        return props.profileSocialMediaViewObject
    }

    private func mapToProfileInformationViewObject(props: Props) -> ProfileInformationViewObject? {
        return props.profileInformationViewObject
    }
}

// MARK: - Preview

struct ProfileScreenView_Previews: PreviewProvider {
    static var previews: some View {
        // Success時の画面表示
        let profileSuccessStore = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                profileMockSuccessMiddleware()
            ]
        )
        ProfileScreenView()
            .environmentObject(profileSuccessStore)
            .previewDisplayName("Profile Secreen Success Preview")
        // Failure時の画面表示
        let profileFailureStore = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                profileMockFailureMiddleware()
            ]
        )
        ProfileScreenView()
            .environmentObject(profileFailureStore)
            .previewDisplayName("Profile Secreen Failure Preview")
    }
}
