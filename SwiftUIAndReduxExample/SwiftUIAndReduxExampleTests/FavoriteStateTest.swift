//
//  FavoriteStateTest.swift
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

final class FavoriteStateTest: QuickSpec {

    // MARK: - Override

    override func spec() {

        // MEMO: Quick+NimbleをベースにしたUnitTestを実行する
        // ※注意: Middlewareを直接適用するのではなく、Middlewareで起こるActionに近い形を作ることにしています。
        describe("#Favorite画面表示が成功する場合のテストケース") {
            // 👉 storeをインスタンス化する際に、想定するMiddlewareのMockを適用する
            let store = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: []
            )
            // CombineExpectationを利用してAppStateの変化を記録するようにしたい
            // 👉 このサンプルではAppStateで`@Published`を利用しているので、AppStateを記録対象とする
            var favoriteStateRecorder: Recorder<AppState, Never>!
            context("表示するデータ取得処理が成功する場合") {
                beforeEach {
                    favoriteStateRecorder = store.$state.record()
                }
                afterEach {
                    favoriteStateRecorder = nil
                }
                // 👉 Middlewareで実行するAPIリクエストが成功した際に想定されるActionを発行する
                store.dispatch(
                    action: SuccessFavoriteAction(
                        favoriteSceneEntities: getFavoriteSceneEntities()
                    )
                )
                // 対象のState値が変化することを確認する
                // ※ favoriteStateはImmutable / Recorderで対象秒間における値変化を全て保持している
                it("favoriteStateに想定している値が格納された状態であること") {
                    // timeout部分で0.16秒後の変化を見る
                    let favoriteStateRecorderResult = try! self.wait(for: favoriteStateRecorder.availableElements, timeout: 0.16)
                    // 0.16秒間の変化を見て、最後の値が変化していることを確認する
                    let targetResult = favoriteStateRecorderResult.last!
                    // 👉 特徴的なテストケースをいくつか準備する（このテストコードで返却されるのは仮のデータではあるものの該当Stateにマッピングされる想定）
                    let favoriteState = targetResult.favoriteState
                    // favoritePhotosCardViewObjects
                    let favoritePhotosCardViewObjects = favoriteState.favoritePhotosCardViewObjects
                    let firstFavoritePhotosCardViewObject = favoritePhotosCardViewObjects.first
                    // 編集部が選ぶお気に入りのグルメは合計12件取得できること
                    expect(favoritePhotosCardViewObjects.count).to(equal(12))
                    // 最初のidが正しい値であること
                    expect(firstFavoritePhotosCardViewObject?.id).to(equal(1))
                    // 最初のtitleが正しい値であること
                    expect(firstFavoritePhotosCardViewObject?.title).to(equal("気になる一皿シリーズNo.1"))
                }
            }
        }

        describe("#Favorite画面表示が失敗する場合のテストケース") {
            let store = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: []
            )
            var favoriteStateRecorder: Recorder<AppState, Never>!
            context("#Favorite画面で表示するデータ取得処理が失敗した場合") {
                beforeEach {
                    favoriteStateRecorder = store.$state.record()
                }
                afterEach {
                    favoriteStateRecorder = nil
                }
                store.dispatch(action: FailureFavoriteAction())
                it("favoriteStateのisErrorがtrueとなること") {
                    let favoriteStateRecorderResult = try! self.wait(for: favoriteStateRecorder.availableElements, timeout: 0.16)
                    let targetResult = favoriteStateRecorderResult.last!
                    let favoriteState = targetResult.favoriteState
                    let isError = favoriteState.isError
                    expect(isError).to(equal(true))
                }
            }
        }
    }

    // MARK: - Private Function

    private func getFavoriteSceneEntities() -> [FavoriteSceneEntity] {
        guard let path = Bundle.main.path(forResource: "favorite_scenes", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([FavoriteSceneEntity].self, from: data) else {
            fatalError()
        }
        return result
    }
}
