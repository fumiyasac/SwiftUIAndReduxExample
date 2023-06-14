# SwiftUIAndReduxExample
[ING] - SwiftUIとReduxで作るサンプルアプリ

SwiftUIを利用した表現＆Reduxを利用した画面状態管理を組み合わせたUI実装サンプルになります。

※ 2023.03.07に開催された「YUMEMI.grow Mobile #1」での登壇資料はこちらになります。
- [SwiftUI&Reduxを利用したUI実装サンプルにおけるポイント解説](https://speakerdeck.com/fumiyasac0921/swiftui-and-reduxwoli-yong-sitauishi-zhuang-sanpuruniokerupointojie-shuo)

※ 記事として登壇内容をまとめたものはこちらになります。
- [解説記事はこちら](https://zenn.dev/fumiyasac/articles/01f1bc86bf8c40)

## 1. サンプル概要

基本的には、APIから画面表示に必要なデータを取得した後に画面表示をする機能を中心として、一部の画面では「お気に入り機能」の様な形でアプリ内部にデータを永続化して保持しておく機能や、表示一覧データをキーワードやカテゴリーに合致するものだけをフィルタリングする「絞り込み検索」の様な形で表示する画面も実装しています。

### 1-1. 動画で見る画面の振る舞いと実機転送時の注意点

- [📱UI実装サンプルの挙動を収録した動画](https://www.facebook.com/100001580558958/videos/734931384655279/)

![実機確認時に利用するBuild Targetの指定](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/build-target-setting.png)

### 1-2. 画面キャプチャ

__【その1】__

<img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/sample_screen1.png" width="320"> <img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/sample_screen2.png" width="320">

__【その2】__

<img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/sample_screen3.png" width="320"> <img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/sample_screen4.png" width="320">

## 2. ReduxをSwiftUI画面に導入するにあたって

以前に、UIKitベースのiOSアプリ開発やReactNativeに触れた経験の中でReduxに触れる機会があったので、SwiftUIでも自分で試してみたいと思ったことがきっかけで組んだ次第です。

※また裏テーマとして、[TCA(The Composable Architecture)](https://swiftpack.co/package/pointfreeco/swift-composable-architecture)を理解するための布石としたり、類似点や相違点等の違いを比較したい意図もあったりします。

### 参考資料

このサンプルを作り始めた際はSwiftUIでの実装経験があまりなかった事もあり、Udemy講座を受講した後に基本事項や少し複雑めな構成を取る際のポイントをある程度押さえる用に取り組んでいました。下記に受講した講座とその中で重要と感じた点をまとめたノートやそのた参考リンクを掲載しております。

__【活用したUdemy講座】__

- [Composable SwiftUI Architecture Using Redux](https://www.udemy.com/course/composable-swiftui-architecture-using-redux/)
  - [取り組んだ講座の要点をまとめたノート](https://twitter.com/fumiyasac/status/1582883611681861632)
- [SwiftUI 2 - Build Netflix Clone - SwiftUI Best Practices](https://www.udemy.com/course/swiftui-netflix/)
  - [取り組んだ講座の要点をまとめたノート(1)](https://twitter.com/fumiyasac/status/1590499801095081986)
  - [取り組んだ講座の要点をまとめたノート(2)](https://twitter.com/fumiyasac/status/1590499949653168128)
  - [取り組んだ講座の要点をまとめたノート(3)](https://twitter.com/fumiyasac/status/1590500054963740672)

__【SwiftUIとReduxを組み合わせた場合の事例】__

- [Redux入門 〜iOSアプリをReduxで作ってみた〜](https://creators-note.chatwork.com/entry/2021/05/20/100000)
- [Managing SwiftUI State Using A Redux-Like Framework](https://medium.com/neudesic-innovation/managing-swiftui-state-using-redux-525a8879c1be)

__【UIKitとReduxを組み合わせた場合の事例】__

- [Redux+Rxを活用したiOSアプリアーキテクチャ](https://qiita.com/susieyy/items/23d44f28c6a6915c58e2)
- [SwiftでReduxを実現するReSwiftを使ってみた](https://qiita.com/hachinobu/items/19265ee6c987844e7b08)
- [ReduxとSwiftの組み合わせを利用したUIサンプル事例紹介](https://qiita.com/fumiyasac@github/items/f25465a955afdcb795a2)

__【TCA（The Composable Architecture）とRedux比較した際の所感等】__

- [ReduxとTCAの特徴的な部分や違いを簡単にまとめてみたノート📝](https://twitter.com/fumiyasac/status/1592062777388339204)

## 3. このサンプル実装におけるReduxと各層での処理

今回のサンプルでは、下記のような形でReduxの処理を実現するために必要な要素を役割ごとのファイルに分割した上でまとめています。さらに命名によって画面ごとにそれぞれのStateが対応するようにしています。

- __Store__:
  👉 アプリケーション全体の状態(複数の画面表示用State)を一枚岩の様な形で保持する。
- __Action__:
  👉 Storeが保持している状態(対象の画面表示用State)を更新するための唯一の手段でstructで定義する。<br>(重要) Actionの発行はStoreが提供している`store.dispatch()`を実行する形となります。
- __Reducer__:
  👉 現在の状態(対象の画面表示用State)とActionの内容から新しい状態を作成する部分で純粋関数として定義する。
- __Middleware__:
  👉 Reducerの実行前後で処理を差し込むための部分で純粋関数として定義する。<br>(重要) 画面表示に必要なMiddleware内部で、API非同期通信処理や内部データ登録処理等を実施する形となります。

この様な形にすることで、画面を構成しているView要素については、主に下記の処理に限定する事が可能になります。

1. __Storeから受け取った画面用State値を反映する__
2. __ボタン押下処理等の部分に画面用Stateを変更するAction発行処理を記載する__

画面用State変化とUI変化をうまく結びつけるためには、できるだけ`「Stateの値 = アプリのUI要素の状態」`という形となる様に、State構造やUI関連処理に関する設計をする点がポイントになると考えております。すなわち、`「各状態におけるデータとUIのあるべき姿を整理する」 `点が重要になると思います。

※ React.jsでも利用されている様なReduxの処理機構を、SwiftUIで表現した様なイメージで作成しています。

__【このUIサンプル実装におけるStore部分の実装】__

各画面に対応するStateを集約している`AppState（ReduxStateプロトコル準拠）`の部分については、`@Published`で定義しています。

<details>
<summary>Store.swiftの実装コード</summary>

```swift
import Foundation

// MEMO: Store部分はasync/awaitで書くなら、MainActorで良いんじゃないかという仮説
// https://developer.apple.com/forums/thread/690957

// FYI: 他にも全体的にCombineを利用した書き方も可能 (※他にも事例は探してみると面白そう)
// https://wojciechkulik.pl/ios/redux-architecture-and-mind-blowing-features
// https://kazaimazai.com/redux-in-ios/
// https://www.raywenderlich.com/22096649-getting-a-redux-vibe-into-swiftui

// MARK: - Typealias

// 👉 Dispatcher・Reducer・Middlewareのtypealiasを定義する
// ※おそらくエッセンスとしてはReact等の感じに近くなるイメージとなる
typealias Dispatcher = (Action) -> Void
typealias Reducer<State: ReduxState> = (_ state: State, _ action: Action) -> State
typealias Middleware<StoreState: ReduxState> = (StoreState, Action, @escaping Dispatcher) -> Void

// MARK: - Protocol

protocol ReduxState {}

protocol Action {}

// MARK: - Store

final class Store<StoreState: ReduxState>: ObservableObject {

    // MARK: - Property
    @Published private(set) var state: StoreState
    private var reducer: Reducer<StoreState>
    private var middlewares: [Middleware<StoreState>]

    // MARK: - Initialzer
    init(
        reducer: @escaping Reducer<StoreState>,
        state: StoreState,
        middlewares: [Middleware<StoreState>] = []
    ) {
        self.reducer = reducer
        self.state = state
        self.middlewares = middlewares
    }

    // MARK: - Function
    func dispatch(action: Action) {

        // MEMO: Actionを発行するDispatcherの定義
        // 👉 新しいstateに差し替える処理については、メインスレッドで操作したいのでMainActor内で実行する
        Task { @MainActor in
            self.state = reducer(
                self.state,
                action
            )
        }

        // MEMO: 利用する全てのMiddlewareを適用
        // 補足: MiddlewareにAPI通信処理等を全て寄せずに実装したい場合には別途ActionCreatorの様なStructを用意する方法もある
        // https://qiita.com/fumiyasac@github/items/f25465a955afdcb795a2
        middlewares.forEach { middleware in
            middleware(state, action, dispatch)
        }
    }
}
```

</details>

### 3-1. 全体像の概略図

![本サンプルで利用しているReduxの概要図と処理フロー](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/3-1-fundamental_of_redux.png)

### 3-2. Middlewareで実行する処理と各種機能とのつながり

![Middleware内で実行されている処理と結果に応じたAction発行](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/3-2-example_of_middleware.png)

### 3-3. Storeの内容を子のView要素で利用する

```swift
// 👉 アプリの一番おおもと部分でStoreを定義する 
let store = Store(
    reducer: appReducer,
    state: AppState(),
    middlewares: [
        // OnBoarding処理用Middleware
        onboardingMiddleware(),
        onboardingCloseMiddleware(),
        // Home処理用Middleware
        homeMiddleware(),
        // Archive処理用Middleware
        archiveMiddleware(),
        addArchiveObjectMiddleware(),
        deleteArchiveObjectMiddleware(),
        // Favorite処理用Middleware
        favoriteMiddleware(),
        // Profile処理用Middleware
        profileMiddleware(),
    ]
)

// 👉 ContentView(ScreenView)に対してenvironmentObjectを経由してstoreを渡す
WindowGroup {
    ContentView()
        .environmentObject(store)
}

// 👉 渡されたView(ScreenView)では下記の様な形でstoreを利用する
@EnvironmentObject var store: Store<AppState>
```

## 4. UI実装や表現に関連するTIPS紹介

本サンプルにおけるUI実装に関しては、一部`DragGesture`の処理を活用したCarousel表現や局所的に`GeometryReader`を利用した表現を画面のSection要素内に取り入れて組み合わせた様な形となっています。

`DragGesture`を活用した奥行きのある無限Carouselの実装や、PinterestのようなGrid表示については、`UIKit + UICollectionView`を利用した実装を選択した場合でも、`UICollectionViewDelegateFlowLayout`クラスを継承した独自のレイアウト定義等を活用したカスタマイズが必要になるので、結果的にはなかなか一筋縄ではいかないUI実装になる事は多いかと思います。

※ Home画面及びFavorite画面で利用されているUI表現に関する解説の詳細は、下記のQiita記事でまとめていますので、ご一読頂けますと幸いです。

- [SwiftUIで作る「Drag処理を利用したCarousel型UI」と「Pinterest風GridレイアウトUI」の実装例とポイントまとめ](https://qiita.com/fumiyasac@github/items/b5b313d9807ff858a73c)

### 4-1. Home画面 & Favorite画面におけるUI実装のポイント図解

__【UI表現例: その1】__

![Drag処理に伴って回転&奥行きのある無限循環型Carouselを実現するDragGesture活用例](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/4-1-1-3d_carousel_example.png)

__【UI表現例: その2】__

![Drag処理と連動した中央寄せ型のCarouselを実現するDragGesture活用例](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/4-1-2-drag_carousel_example.png)

__【UI表現例: その3】__

![LazyHStackとScrollViewで作成するシンプルなCarousel表現](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/4-1-3-simple_horizontal_carousel_example.png)

__【UI表現例: その4】__

![基本的なLazyVGridを利用したGrid](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/4-1-4-simple_2column_grid_example.png)

__【UI表現例: その5】__

![HStackと2つのVStackを並べて合計の高さを基準としたロジックを元に構築したGrid](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/4-1-5-waterfall_grid_example.png)

__【UI表現例: その6】__

![OSSライブラリ「CollectionViewPagingLayout」を利用した表現](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/4-1-6-swipe_paging_example.png)

### 4-2. Profile画面におけるUI実装のポイント図解

![Profile画面における特徴的なUI表現をする部分](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/4-2-profile_ui_example.png)

### 4-3. Archive画面におけるUI実装のポイント図解

![Archive画面における特徴的なUI表現をする部分](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/4-3-archive_ui_example.png)

## 5. Mockサーバー環境構築

サンプルアプリ内では、APIモックサーバーから受け取ったJSON形式のレスポンスを画面に表示する処理を実現するために、node.js製の __「json-server」__ を利用して実現しています。（※こちらはTypeScript製のものを利用しています。）

このリポジトリをClone後に下記コマンドを実行することで、自分のローカル環境で動作させる事ができます。

サンプルアプリ内にAPIモックサーバーから受け取ったJSON形式のレスポンスを画面に表示する処理を実現するために、Node.js製の「JSONServer」というものを利用して実現しています。JSONServerに関する概要や基本的な活用方法につきましては下記のリンク等を参考にすると良いかと思います。

※ 自分のLocal環境に`node.js`と`yarn`がインストールされていない場合は、まずはその準備をする必要があります

__【Local環境で再現する手順】__

```shell
# まずはMockサーバーの場所まで移動する
$ cd SwiftUIAndReduxExample/mock_server
# 必要なpackageのインストール
$ yarn install
# Mockサーバーの実行
$ yarn start
```

※ 自分の手元でまっさらな状態から準備する場合は下記コマンドを順次実行するイメージになります。

__【Local環境で新規作成する場合の手順】__

```shell
# ⭐️ 必要な実行コマンド
# ① package.jsonの新規作成
$ yarn init -y
# ② 必要なライブラリのインストール
$ yarn add typescript
$ yarn add json-server
$ yarn add @types/json-server -D
```

※ こちらはMockサーバーを実行するために最低限必要な設定を記載した`package.json`になります。

__【package.json設定例】__

```json
{
  "name": "mock_server",
  "version": "1.0.0",
  "main": "server.ts",
  "license": "MIT",
  "dependencies": {
    "json-server": "^0.17.0",
    "typescript": "^4.7.4"
  },
  "scripts": {
    "start": "npx ts-node server.ts"
  },
  "devDependencies": {
    "@types/json-server": "^0.14.4"
  }
}
```

### 参考資料

- [json-serverの実装に関する参考資料](https://blog.eleven-labs.com/en/json-server)
- [TypeScriptで始めるNode.js入門](https://ics.media/entry/4682/)
- [JSON ServerをCLIコマンドを使わずTypescript＆node.jsからサーバーを立てるやり方](https://deep.tacoskingdom.com/blog/151)

## 6. 設計時のメモ書き

余談にはなりますが、最近作っていたUI実装サンプルのアイデアや盛り込みたい機能イメージを雑に書いたものになります。
今回は1つの画面内に複数Sectionが入るものやUI実装イメージが湧きにくいものに加えて、API関連処理部分でasync/awaitを利用することもあったので、自分が __「ここはハマりそうかも...?」__ や __「UIの形や表現を自分の言葉でまとめておこう」__ と感じた部分を中心にメモとして残しています。

![各種画面に関する構想やasync/awaitを利用した並列処理に関連するメモ](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/design_memo.png)

## 7. UnitTestに関する補足

[Quick](https://github.com/Quick/Quick) / [Nimble](https://github.com/Quick/Nimble) / [CombineExpectations](https://github.com/groue/CombineExpectations) を利用し、__「初期State → Action発行 → API処理が伴う部分ではMiddleware処理実行時に準ずるActionを発行 → 新規State」__ とすることで、Reducerでの処理が正しく実行されているかを見る方針としました。

また、各画面に対応するStateをまとめて管理しているAppStateは`@Published`で定義されているため、下記の様な形で値変化をキャッチする点がポイントになるかと思います。

__【Case1: Home画面でのテスト例】__

<details>
<summary>HomeStateTest.swiftの実装コード</summary>

```swift
final class HomeStateTest: QuickSpec {

    // MARK: - Override

    override func spec() {

        // MEMO: Quick+NimbleをベースにしたUnitTestを実行する
        // ※注意: Middlewareを直接適用するのではなく、Middlewareで起こるActionに近い形を作ることにしています。
        describe("#Home画面表示が成功する場合のテストケース") {
            // 👉 storeをインスタンス化する際に、想定するMiddlewareのMockを適用する
            let store = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: []
            )
            // CombineExpectationを利用してAppStateの変化を記録するようにしたい
            // 👉 このサンプルではAppStateで`@Published`を利用しているので、AppStateを記録対象とする
            var homeStateRecorder: Recorder<AppState, Never>!
            context("表示するデータ取得処理が成功する場合") {
                beforeEach {
                    homeStateRecorder = store.$state.record()
                }
                afterEach {
                    homeStateRecorder = nil
                }
                // 👉 Middlewareで実行するAPIリクエストが成功した際に想定されるActionを発行する
                store.dispatch(
                    action: SuccessHomeAction(
                        campaignBannerEntities: getCampaignBannerEntities(),
                        recentNewsEntities: getRecentNewsRecentNewsEntities(),
                        featuredTopicEntities: getFeaturedTopicEntities(),
                        trendArticleEntities: getTrendArticleEntities(),
                        pickupPhotoEntities: getPickupPhotoEntities()
                    )
                )
                // 対象のState値が変化することを確認する
                // ※ homeStateはImmutable / Recorderで対象秒間における値変化を全て保持している
                it("homeStateに想定している値が格納された状態であること") {
                    // timeout部分で0.16秒後の変化を見る（※async/await処理の場合は0.16秒ぐらいを見る）
                    let homeStateRecorderResult = try! self.wait(for: homeStateRecorder.availableElements, timeout: 0.16)
                    // 0.16秒間の変化を見て、最後の値が変化していることを確認する
                    let targetResult = homeStateRecorderResult.last!
                    // 👉 特徴的なテストケースをいくつか準備する（このテストコードで返却されるのは仮のデータではあるものの該当Stateにマッピングされる想定）
                    let homeState = targetResult.homeState
                    // (1) CampaignBannerCarouselViewObject
                    let campaignBannerCarouselViewObjects = homeState.campaignBannerCarouselViewObjects
                    let firstCampaignBannerCarouselViewObject = campaignBannerCarouselViewObjects.first
                    // 季節の特集コンテンツ一覧は合計6件取得できること
                    expect(campaignBannerCarouselViewObjects.count).to(equal(6))
                    // 1番目のidが正しい値であること
                    expect(firstCampaignBannerCarouselViewObject?.id).to(equal(1))
                    // 1番目のbannerContentsIdが正しい値であること
                    expect(firstCampaignBannerCarouselViewObject?.bannerContentsId).to(equal(1001))
                    // (2) RecentNewsCarouselViewObject
                    let recentNewsCarouselViewObjects = homeState.recentNewsCarouselViewObjects
                    let lastCampaignBannerCarouselViewObject = recentNewsCarouselViewObjects.last
                    // 最新のお知らせは合計12件取得できること
                    expect(recentNewsCarouselViewObjects.count).to(equal(12))
                    // 最後のidが正しい値であること
                    expect(lastCampaignBannerCarouselViewObject?.id).to(equal(12))
                    // 最後のtitleが正しい値であること
                    expect(lastCampaignBannerCarouselViewObject?.title).to(equal("美味しいみかんの年末年始の対応について"))
                }
            }
        }

        describe("#Home画面表示が失敗する場合のテストケース") {
            let store = Store(
                reducer: appReducer,
                state: AppState(),
                middlewares: []
            )
            var homeStateRecorder: Recorder<AppState, Never>!
            context("#Home画面で表示するデータ取得処理が失敗した場合") {
                beforeEach {
                    homeStateRecorder = store.$state.record()
                }
                afterEach {
                    homeStateRecorder = nil
                }
                store.dispatch(action: FailureHomeAction())
                it("homeStateのisErrorがtrueとなること") {
                    let homeStateRecorderResult = try! self.wait(for: homeStateRecorder.availableElements, timeout: 0.16)
                    let targetResult = homeStateRecorderResult.last!
                    let homeState = targetResult.homeState
                    let isError = homeState.isError
                    expect(isError).to(equal(true))
                }
            }
        }
    }

    // MARK: - Private Function

    private func getCampaignBannerEntities() -> [CampaignBannerEntity] {
        guard let path = Bundle.main.path(forResource: "campaign_banners", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([CampaignBannerEntity].self, from: data) else {
            fatalError()
        }
        return result
    }

    private func getRecentNewsRecentNewsEntities() -> [RecentNewsEntity] {
        guard let path = Bundle.main.path(forResource: "recent_news", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([RecentNewsEntity].self, from: data) else {
            fatalError()
        }
        return result
    }

    private func getFeaturedTopicEntities() -> [FeaturedTopicEntity] {
        guard let path = Bundle.main.path(forResource: "featured_topics", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([FeaturedTopicEntity].self, from: data) else {
            fatalError()
        }
        return result
    }

    private func getTrendArticleEntities() -> [TrendArticleEntity] {
        guard let path = Bundle.main.path(forResource: "trend_articles", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([TrendArticleEntity].self, from: data) else {
            fatalError()
        }
        return result
    }

    private func getPickupPhotoEntities() -> [PickupPhotoEntity] {
        guard let path = Bundle.main.path(forResource: "pickup_photos", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([PickupPhotoEntity].self, from: data) else {
            fatalError()
        }
        return result
    }
}
```

</details>

__【Case2: Archive画面でのテスト例】__

<details>
<summary>ArchiveStateTest.swiftの実装コード</summary>

```swift
final class ArchiveStateTest: QuickSpec {
    
    // MARK: - Override
    
    override func spec() {
        
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
                    let archiveStateRecorderResult = try! self.wait(for: archiveStateRecorder.availableElements, timeout: 0.16)
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
                    let archiveStateRecorderResult = try! self.wait(for: archiveStateRecorder.availableElements, timeout: 0.16)
                    let targetResult = archiveStateRecorderResult.last!
                    let archiveState = targetResult.archiveState
                    let isError = archiveState.isError
                    expect(isError).to(equal(true))
                }
            }
        }
        
    }

    // MARK: - Private Function

    private func getArchiveSceneEntities() -> [ArchiveSceneEntity] {
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
```

</details>

## 8. Repository層及びMiddleware層で適用するMockに関する補足

Preview画面では、API通信部分やデータ永続化が関係するMiddleware層（あるいはRepository層）の処理については、実際の振る舞いを模したMock用のクラスを適用しています。

### 8-1. Repository層のMock定義例

実際にAPI処理を実行させる形でもこのサンプル実装においては差し支えはありませんが、各種UI要素におけるPreview画面や実機検証の際に利用するビルドターゲット`SwiftUIAndReduxExampleMockApi`では下記の様な形でMock処理を使う様にしています。

__【Case1: API通信部分のMock例】__

<details>
<summary>Mock込みのRequestArchiveRepository.swift実装コード</summary>

```swift
// MARK: - Protocol

protocol RequestArchiveRepository {
    func getArchiveResponse(keyword: String, category: String) async throws -> ArchiveResponse
}

final class RequestArchiveRepositoryImpl: RequestArchiveRepository {

    // MARK: - Function

    // 👉 検索キーワードと選択カテゴリーに合致する一覧データ取得APIリクエスト処理を実行する

    func getArchiveResponse(keyword: String, category: String) async throws -> ArchiveResponse {
        return try await ApiClientManager.shared.getAchiveImages(keyword: keyword, category: category)
    }
}

// MARK: - MockSuccessRequestArchiveRepositoryImpl

final class MockSuccessRequestArchiveRepositoryImpl: RequestArchiveRepository {

    // MARK: - Function

    // 👉 実際にAPIリクエスト処理で実行される処理に相当するものをMockで再現する

    func getArchiveResponse(keyword: String, category: String) async throws -> ArchiveResponse {
        // 第2引数で与えられるcategoryと全く同じ値であるものだけを取り出す
        // 第1引数で与えられるkeywordが(dishName / shopName / introduction)いずれかに含まれるものだけを取り出す
        var filteredResult = getArchiveSceneResponse().result
        if !category.isEmpty {
            filteredResult = filteredResult.filter { $0.category == category }
        }
        if !keyword.isEmpty {
            filteredResult = filteredResult.filter { $0.dishName.contains(keyword) || $0.shopName.contains(keyword)  || $0.introduction.contains(keyword) }
        }
        return ArchiveSceneResponse(result: filteredResult)
    }

    // MARK: - Private Function

    private func getArchiveSceneResponse() -> ArchiveSceneResponse {
        guard let path = Bundle.main.path(forResource: "achive_images", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([ArchiveSceneEntity].self, from: data) else {
            fatalError()
        }
        return ArchiveSceneResponse(result: result)
    }
}
```

</details>

__【Case2: データ永続化部分のMock例】__

<details>
<summary>Mock込みのStoredArchiveDataRepository.swift実装コード</summary>

```swift
// MARK: - Protocol

protocol StoredArchiveDataRepository {
    func getAllObjectsFromRealm() -> [StockArchiveRealmEntity]
    func createToRealm(archiveCellViewObject: ArchiveCellViewObject)
    func deleteFromRealm(archiveCellViewObject: ArchiveCellViewObject)
}

final class StoredArchiveDataRepositoryImpl: StoredArchiveDataRepository {

    // MARK: - Function

    // 👉 Realmから全件取得処理・Realmへの1件追加・1件削除処理を実行する

    func getAllObjectsFromRealm() -> [StockArchiveRealmEntity] {
        if let stockArchiveRealmEntities = RealmAccessManager.shared.getAllObjects(StockArchiveRealmEntity.self) {
            return stockArchiveRealmEntities.map { $0 }
        } else {
            return []
        }
    }

    func createToRealm(archiveCellViewObject: ArchiveCellViewObject) {
        let stockArchiveRealmEntity = convertToRealmObject(archiveCellViewObject: archiveCellViewObject)
        RealmAccessManager.shared.saveStockArchiveRealmEntity(stockArchiveRealmEntity)
    }

    func deleteFromRealm(archiveCellViewObject: ArchiveCellViewObject) {
        if let stockArchiveRealmEntities = RealmAccessManager.shared.getAllObjects(StockArchiveRealmEntity.self),
           let stockArchiveRealmEntity = stockArchiveRealmEntities.map({ $0 }).filter({ $0.id == archiveCellViewObject.id }).first
        {
            RealmAccessManager.shared.deleteStockArchiveRealmEntity(stockArchiveRealmEntity)
        } else {
            fatalError("削除対象のデータは登録されていませんでした。")
        }
    }

    // MARK: - Private Function

    private func convertToRealmObject(archiveCellViewObject: ArchiveCellViewObject) -> StockArchiveRealmEntity {
        let realmObject = StockArchiveRealmEntity()
        realmObject.id = archiveCellViewObject.id
        realmObject.photoUrl = archiveCellViewObject.photoUrl?.absoluteString ?? ""
        realmObject.category = archiveCellViewObject.category
        realmObject.dishName = archiveCellViewObject.dishName
        realmObject.shopName = archiveCellViewObject.shopName
        realmObject.introduction = archiveCellViewObject.introduction
        return realmObject
    }
}

final class MockStoredArchiveDataRepositoryImpl: StoredArchiveDataRepository {

    // MARK: - Function

    // 👉 実際にデータ永続化処理で実行される処理に相当するものをMockで再現する

    func getAllObjectsFromRealm() -> [StockArchiveRealmEntity] {
        return RealmMockAccessManager.shared.mockDataStore.values.map({ $0 })
    }

    func createToRealm(archiveCellViewObject: ArchiveCellViewObject) {
        RealmMockAccessManager.shared.mockDataStore[archiveCellViewObject.id] = convertToRealmObject(archiveCellViewObject: archiveCellViewObject)
    }

    func deleteFromRealm(archiveCellViewObject: ArchiveCellViewObject) {
        RealmMockAccessManager.shared.mockDataStore.removeValue(forKey: archiveCellViewObject.id)
    }

    // MARK: - Private Function

    private func convertToRealmObject(archiveCellViewObject: ArchiveCellViewObject) -> StockArchiveRealmEntity {
        let realmObject = StockArchiveRealmEntity()
        realmObject.id = archiveCellViewObject.id
        realmObject.photoUrl = archiveCellViewObject.photoUrl?.absoluteString ?? ""
        realmObject.category = archiveCellViewObject.category
        realmObject.dishName = archiveCellViewObject.dishName
        realmObject.shopName = archiveCellViewObject.shopName
        realmObject.introduction = archiveCellViewObject.introduction
        return realmObject
    }
}
```

</details>

### 8-2. Repository層のMockを適用したMiddlewareとStoreへの適用

Middlewareはメソッドとして提供されるので、Repositoryの本実装を適用したメソッドとRepositoryのMock実装を適用したメソッドの2種類を用意する形になります。

<details>
<summary>ArchiveMiddleware.swiftに定義した本実装時のメソッド</summary>

```swift
// MARK: - Function (Production)

// APIリクエスト結果に応じたActionを発行する
// ※テストコードの場合は検証用のarchiveMiddlewareのものに差し替える想定
func archiveMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            // 👉 選択カテゴリー・入力テキスト値の変更を受け取ったらその後にAPIリクエスト処理を実行する
            // 複合条件の処理をするために現在Stateに格納されている値も利用する
            case let action as RequestArchiveWithInputTextAction:
            let selectedCategory = state.archiveState.selectedCategory
            requestArchiveScenes(
                inputText: action.inputText,
                selectedCategory: selectedCategory,
                dispatch: dispatch
            )
            case let action as RequestArchiveWithSelectedCategoryAction:
            let inputText = state.archiveState.inputText
            requestArchiveScenes(
                inputText: inputText,
                selectedCategory: action.selectedCategory,
                dispatch: dispatch
            )
            case _ as RequestArchiveWithNoConditionsAction:
            requestArchiveScenes(
                inputText: "",
                selectedCategory: "",
                dispatch: dispatch
            )
            default:
                break
        }
    }
}

// MARK: - Private Function (Production)

// 👉 APIリクエスト処理を実行するためのメソッド
// ※テストコードの場合は想定するStubデータを返すものに差し替える想定
private func requestArchiveScenes(inputText: String, selectedCategory: String, dispatch: @escaping Dispatcher) {
    Task { @MainActor in
        do {
            // 👉 Realm内に登録されているデータのIDだけを詰め込んだ配列に変換する
            let storedIds = StoredArchiveDataRepositoryFactory.create().getAllObjectsFromRealm()
                .map { $0.id }
            // 👉 Realm内に登録されているデータのIDだけを詰め込んだ配列に変換する
            // 🌟 最終的にViewObjectに変換をするのはArchiveReducerで実行する
            let archiveResponse = try await RequestArchiveRepositoryFactory.create().getArchiveResponse(keyword: inputText, category: selectedCategory)
            if let archiveSceneResponse = archiveResponse as? ArchiveSceneResponse {
                // お望みのレスポンスが取得できた場合は成功時のActionを発行する
                dispatch(
                    SuccessArchiveAction(
                        archiveSceneEntities: archiveSceneResponse.result,
                        storedIds: storedIds
                    )
                )
            } else {
                // お望みのレスポンスが取得できなかった場合はErrorをthrowして失敗時のActionを発行する
                throw APIError.error(message: "No FavoriteSceneResponse exists.")
            }
            dump(archiveResponse)
        } catch APIError.error(let message) {
            // 通信エラーないしはお望みのレスポンスが取得できなかった場合は成功時のActionを発行する
            dispatch(FailureArchiveAction())
            print(message)
        }
    }
}
```

</details>


<details>
<summary>ArchiveMiddleware.swiftに定義したMock時のメソッド</summary>

```swift
// MARK: - Function (Mock for Success)

// テストコードで利用するAPIリクエスト結果に応じたActionを発行する（Success時）
func archiveMockSuccessMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        // 👉 本来はAPIリクエスト処理やRealmからのデータ取得処理をMockに置き換えたもので代用する関数を実行する
        switch action {
            case let action as RequestArchiveWithInputTextAction:
            let selectedCategory = state.archiveState.selectedCategory
            mockSuccessRequestArchiveScenes(
                inputText: action.inputText,
                selectedCategory: selectedCategory,
                dispatch: dispatch
            )
            case let action as RequestArchiveWithSelectedCategoryAction:
            let inputText = state.archiveState.inputText
            mockSuccessRequestArchiveScenes(
                inputText: inputText,
                selectedCategory: action.selectedCategory,
                dispatch: dispatch
            )
            case _ as RequestArchiveWithNoConditionsAction:
            mockSuccessRequestArchiveScenes(
                inputText: "",
                selectedCategory: "",
                dispatch: dispatch
            )
            default:
                break
        }
    }
}

// MARK: - Function (Mock for Failure)

// テストコードで利用するAPIリクエスト結果に応じたActionを発行する（Failure時）
func archiveMockFailureMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
            // 👉 処理失敗を想定したmock用関数を実行する
            case _ as RequestArchiveWithInputTextAction:
                mockFailureRequestArchiveScenes(dispatch: dispatch)
            case _ as RequestArchiveWithSelectedCategoryAction:
                mockFailureRequestArchiveScenes(dispatch: dispatch)
            case _ as RequestArchiveWithNoConditionsAction:
                mockFailureRequestArchiveScenes(dispatch: dispatch)
            default:
                break
        }
    }
}

// MARK: - Private Function (Dispatch Action Success/Failure)

// 👉 成功時のAPIリクエストを想定した処理を実行するためのメソッド
private func mockSuccessRequestArchiveScenes(inputText: String, selectedCategory: String, dispatch: @escaping Dispatcher) {
    Task { @MainActor in
        let _ = try await Task.sleep(for: .seconds(0.64))
        // 👉 実際はRealmへの処理ではあるが、MockはDictionaryを利用する処理としている
        let storedIds = MockStoredArchiveDataRepositoryFactory.create().getAllObjectsFromRealm()
            .map { $0.id }
        let archiveResponse = try await MockSuccessRequestArchiveRepositoryFactory.create().getArchiveResponse(keyword: inputText, category: selectedCategory)
        if let archiveSceneResponse = archiveResponse as? ArchiveSceneResponse {
            dispatch(
                SuccessArchiveAction(
                    archiveSceneEntities: archiveSceneResponse.result,
                    storedIds: storedIds
                )
            )
        } else {
            throw APIError.error(message: "No favoriteSceneResponse exists.")
        }
    }
}

// 👉 失敗時のAPIリクエストを想定した処理を実行するためのメソッド
private func mockFailureRequestArchiveScenes(dispatch: @escaping Dispatcher) {
    Task { @MainActor in
        let _ = try await Task.sleep(for: .seconds(0.64))
        dispatch(FailureArchiveAction())
    }
}
```

</details>

