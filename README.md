# SwiftUIAndReduxExample
[ING] - SwiftUIとReduxで作るサンプルアプリ

SwiftUIを利用した表現＆Reduxを利用した画面状態管理を組み合わせたUI実装サンプルになります。

## 1. サンプル概要

基本的には、APIから画面表示に必要なデータを取得した後に画面表示をする機能を中心として、一部の画面では「お気に入り機能」の様な形でアプリ内部にデータを永続化して保持しておく機能や、表示一覧データをキーワードやカテゴリーに合致するものだけをフィルタリングする「絞り込み検索」の様な形で表示する画面も実装しています。

__【画面キャプチャ: その1】__

<img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/sample_screen1.png" width="320"> <img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/sample_screen2.png" width="320">

__【画面キャプチャ: その2】__

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
  👉 Storeが保持している状態(対象の画面表示用State)を更新するための唯一の手段でstructで定義する。
     (重要) Actionの発行はStoreが提供している`store.dispatch()`を実行する形となります。
- __Reducer__:
  👉 現在の状態(対象の画面表示用State)とActionの内容から新しい状態を作成する部分で純粋関数として定義する。
- __Middleware__:
  👉 Reducerの実行前後で処理を差し込むための部分で純粋関数として定義する。
     (重要) 画面表示に必要なMiddleware内部で、API非同期通信処理や内部データ登録処理等を実施する形となります。

この様な形にすることで、画面を構成しているView要素については、主に下記の処理に限定する事が可能になります。

- 1. Storeから受け取った画面用State値を反映する
- 2. ボタン押下処理等の部分に画面用Stateを変更するAction発行処理を記載する

画面用State変化とUI変化をうまく結びつけるためには、できるだけ`「Stateの値 = アプリのUI要素の状態」`という形となる様に、State構造やUI関連処理に関する設計をする点がポイントになると考えております。すなわち、`「各状態におけるデータとUIのあるべき姿を整理する」 `点が重要になると思います。

※ React.jsでも利用されている様なReduxの処理機構を、SwiftUIで表現した様なイメージで作成しています。

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
