//
//  ProfileStateTest.swift
//  SwiftUIAndReduxExampleTests
//
//  Created by 酒井文也 on 2023/02/07.
//

@testable import SwiftUIAndReduxExample

import XCTest
import Combine
import CombineExpectations
import Nimble
import Quick

// MEMO: CombineExpectationsを利用してUnitTestを作成する
// https://github.com/groue/CombineExpectations#usage

final class ProfileStateTest: QuickSpec {

    // MARK: - Override

    override func spec() {

        // MEMO: Quick+NimbleをベースにしたUnitTestを実行する
        // ※注意: Middlewareを直接適用するのではなく、Middlewareで起こるActionに近い形を作ることにしています。
        describe("#Profile画面表示が成功する場合のテストケース") {
            // 👉 storeをインスタンス化する際に、想定するMiddlewareのMockを適用する
            let store = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: []
            )
            // CombineExpectationを利用してAppStateの変化を記録するようにしたい
            // 👉 このサンプルではAppStateで`@Published`を利用しているので、AppStateを記録対象とする
            var profileStateRecorder: Recorder<AppState, Never>!
            context("表示するデータ取得処理が成功する場合") {
                beforeEach {
                    profileStateRecorder = store.$state.record()
                }
                afterEach {
                    profileStateRecorder = nil
                }
                // 👉 Middlewareで実行するAPIリクエストが成功した際に想定されるActionを発行する
                store.dispatch(
                    action: SuccessProfileAction(
                        profilePersonalEntity: getProfilePersonalEntity(),
                        profileAnnoucementEntities: getProfileAnnoucementEntities(),
                        profileCommentEntities: getProfileCommentEntities(),
                        profileRecentFavoriteEntities: getProfileRecentFavoriteEntities()
                    )
                )
                // 対象のState値が変化することを確認する
                // ※profileStateはImmutable / Recorderで対象秒間における値変化を全て保持している
                it("profileStateに想定している値が格納された状態であること") {
                    // timeout部分で0.16秒後の変化を見る
                    let profileStateRecorderResult = try! self.wait(for: profileStateRecorder.availableElements, timeout: 0.16)
                    // 0.16秒間の変化を見て、最後の値が変化していることを確認する
                    let targetResult = profileStateRecorderResult.last!
                    // 👉 特徴的なテストケースをいくつか準備する（このテストコードで返却されるのは仮のデータではあるものの該当Stateにマッピングされる想定）
                    let profileState = targetResult.profileState
                    // (1) ProfilePersonalViewObject
                    let profilePersonalViewObject = profileState.profilePersonalViewObject
                    // ユーザーIDが正しい値であること
                    expect(profilePersonalViewObject?.id).to(equal(100))
                    // ユーザーのニックネームが正しい値であること
                    expect(profilePersonalViewObject?.nickname).to(equal("謎多き料理人"))
                    // 登録日が正しい値であること
                    expect(profilePersonalViewObject?.createdAt).to(equal("2022.11.16"))
                    // アバターのURLが正しい値であること
                    expect(profilePersonalViewObject?.avatarUrl?.absoluteString)
                        .to(equal("https://ones-mind-topics.s3.ap-northeast-1.amazonaws.com/profile_avatar_sample.jpg"))
                    // (2) ProfileSelfIntroductionViewObject
                    let profileSelfIntroductionViewObject = profileState.profileSelfIntroductionViewObject
                    expect(profileSelfIntroductionViewObject?.introduction)
                        .to(equal("普段は東京でイタリアンレストランのシェフをしていますが、その傍らで自宅でも美味しく食べられる本格イタリアンデザート等のプロデュース等も手掛けております。普段は仕事が忙しいのもあって外食が多くなりがちではあるので、ジャンル問わずに幅広く食べ歩くのが趣味です。ただ最近は運動不足もあってちょっと体重が増えかけているので、自分でもヘルシーな食事を心がけたり、お酒を控えめにしています。よろしくお願いします。"))
                    // (3) ProfileInformationViewObject
                    let profileInformationViewObject = profileState.profileInformationViewObject
                    // profileAnnoucementViewObjectsの登録件数が5件であること
                    expect(profileInformationViewObject?.profileAnnoucementViewObjects.count).to(equal(5))
                    // profileCommentViewObjectsの登録件数が5件であること
                    expect(profileInformationViewObject?.profileCommentViewObjects.count).to(equal(5))
                    // profileRecentFavoriteViewObjectsの登録件数が5件であること
                    expect(profileInformationViewObject?.profileRecentFavoriteViewObjects.count).to(equal(5))
                }
            }
        }

        describe("#Profile画面表示が失敗する場合のテストケース") {
            let store = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: []
            )
            var profileStateRecorder: Recorder<AppState, Never>!
            context("画面で表示するデータ取得処理が失敗した場合") {
                beforeEach {
                    profileStateRecorder = store.$state.record()
                }
                afterEach {
                    profileStateRecorder = nil
                }
                store.dispatch(action: FailureProfileAction())
                it("profileStateRecorderのisErrorがtrueとなること") {
                    let profileStateRecorderResult = try! self.wait(for: profileStateRecorder.availableElements, timeout: 0.16)
                    let targetResult = profileStateRecorderResult.last!
                    let profileState = targetResult.profileState
                    let isError = profileState.isError
                    expect(isError).to(equal(true))
                }
            }
        }
    }

    // MARK: - Private Function

    private func getProfilePersonalEntity() -> ProfilePersonalEntity {
        guard let path = Bundle.main.path(forResource: "profile_personal", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode(ProfilePersonalEntity.self, from: data) else {
            fatalError()
        }
        return result
    }

    private func getProfileAnnoucementEntities() -> [ProfileAnnoucementEntity] {
        guard let path = Bundle.main.path(forResource: "profile_announcement", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ProfileAnnoucementEntity].self, from: data) else {
            fatalError()
        }
        return result
    }

    private func getProfileCommentEntities() -> [ProfileCommentEntity] {
        guard let path = Bundle.main.path(forResource: "profile_comment", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ProfileCommentEntity].self, from: data) else {
            fatalError()
        }
        return result
    }

    private func getProfileRecentFavoriteEntities() -> [ProfileRecentFavoriteEntity] {
        guard let path = Bundle.main.path(forResource: "profile_recent_favorite", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ProfileRecentFavoriteEntity].self, from: data) else {
            fatalError()
        }
        return result
    }
}
