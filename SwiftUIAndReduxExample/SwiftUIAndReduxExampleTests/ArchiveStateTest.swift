//
//  ArchiveStateTest.swift
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

final class ArchiveStateTest: QuickSpec {
    
    // MARK: - Override
    
    override class func spec() {

        // MEMO: Quick+NimbleをベースにしたUnitTestを実行する
        // ※注意: Middlewareを直接適用するのではなく、Middlewareで起こるActionに近い形を作ることにしています。
        describe("#Archive画面表示が成功する場合のテストケース") {
            // 👉 storeをインスタンス化する際に、想定するMiddlewareのMockを適用する
            let store = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: []
            )
            // CombineExpectationを利用してAppStateの変化を記録するようにしたい
            // 👉 このサンプルではAppStateで`@Published`を利用しているので、AppStateを記録対象とする
            var archiveStateRecorder: Recorder<AppState, Never>!
            context("表示するデータ取得処理が成功する場合") {
                beforeEach {
                    archiveStateRecorder = store.$state.record()
                }
                afterEach {
                    archiveStateRecorder = nil
                }
                // 👉 Middlewareで実行するAPIリクエストが成功した際に想定されるActionを発行する
                // 手順1: 検索キーワードとカテゴリーを選択する
                let keyword = "チーズ"
                let category = "洋食"
                store.dispatch(
                    action: RequestArchiveWithInputTextAction(inputText: keyword)
                )
                store.dispatch(
                    action: RequestArchiveWithSelectedCategoryAction(selectedCategory: category)
                )
                var archiveSceneEntities = getArchiveSceneEntities()
                archiveSceneEntities = archiveSceneEntities.filter {
                    $0.category == category
                }
                archiveSceneEntities = archiveSceneEntities.filter {
                    $0.dishName.contains(keyword) || $0.shopName.contains(keyword)  || $0.introduction.contains(keyword)
                }
                // 手順2: 登録されているIDの一覧を設定する
                let storedIds = [17, 33]
                store.dispatch(
                    action: SuccessArchiveAction(
                        archiveSceneEntities: archiveSceneEntities,
                        storedIds: storedIds
                    )
                )
                // 対象のState値が変化することを確認する
                // ※ archiveStateはImmutable / Recorderで対象秒間における値変化を全て保持している
                it("archiveStateに想定している値が格納された状態であること") {
                    // timeout部分で0.16秒後の変化を見る
                    let archiveStateRecorderResult = try! self.current.wait(for: archiveStateRecorder.availableElements, timeout: 0.16)
                    // 0.16秒間の変化を見て、最後の値が変化していることを確認する
                    let targetResult = archiveStateRecorderResult.last!
                    // 👉 特徴的なテストケースをいくつか準備する（このテストコードで返却されるのは仮のデータではあるものの該当Stateにマッピングされる想定）
                    let archiveState = targetResult.archiveState
                    // archiveCellViewObjects / inputText / selectedCategory
                    let archiveCellViewObjects = archiveState.archiveCellViewObjects
                    let inputText = archiveState.inputText
                    let selectedCategory = archiveState.selectedCategory
                    // archiveStateのPropertyへ入力値＆選択値が反映されていること
                    expect(inputText).to(equal("チーズ"))
                    expect(selectedCategory).to(equal("洋食"))
                    // Archive用コンテンツ一覧は合計2件取得できること
                    expect(archiveCellViewObjects.count).to(equal(2))
                    let firstArchiveCellViewObject = archiveCellViewObjects[0]
                    let secondArchiveCellViewObject = archiveCellViewObjects[1]
                    // (1) firstArchiveCellViewObject
                    expect(firstArchiveCellViewObject.id).to(equal(17))
                    expect(firstArchiveCellViewObject.dishName).to(equal("熱々が嬉しいマカロニグラタン"))
                    expect(firstArchiveCellViewObject.isStored).to(equal(true))
                    // (2) secondArchiveCellViewObject
                    expect(secondArchiveCellViewObject.id).to(equal(33))
                    expect(secondArchiveCellViewObject.dishName).to(equal("シーフードミックスピザ"))
                    expect(secondArchiveCellViewObject.isStored).to(equal(true))
                }
            }
        }

        describe("#Archive画面表示が失敗する場合のテストケース") {
            let store = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: []
            )
            var archiveStateRecorder: Recorder<AppState, Never>!
            context("画面で表示するデータ取得処理が失敗した場合") {
                beforeEach {
                    archiveStateRecorder = store.$state.record()
                }
                afterEach {
                    archiveStateRecorder = nil
                }
                store.dispatch(action: FailureArchiveAction())
                it("archiveStateのisErrorがtrueとなること") {
                    let archiveStateRecorderResult = try! self.current.wait(for: archiveStateRecorder.availableElements, timeout: 0.16)
                    let targetResult = archiveStateRecorderResult.last!
                    let archiveState = targetResult.archiveState
                    let isError = archiveState.isError
                    expect(isError).to(equal(true))
                }
            }
        }
        
    }

    // MARK: - Private Function

    private class func getArchiveSceneEntities() -> [ArchiveSceneEntity] {
        guard let path = Bundle.main.path(forResource: "achive_images", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ArchiveSceneEntity].self, from: data) else {
            fatalError()
        }
        return result
    }
}
