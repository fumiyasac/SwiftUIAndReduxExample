# SwiftUIAndReduxExample
[ING] - SwiftUIとReduxで作るサンプルアプリ

SwiftUIを利用した表現＆Reduxを利用した画面状態管理を組み合わせたUI実装サンプルになります。

## 1. サンプル概要

基本的には、APIから画面表示に必要なデータを取得した後に画面表示をする機能を中心として、一部の画面では「お気に入り機能」の様な形でアプリ内部にデータを永続化して保持しておく機能や、表示一覧データをキーワードやカテゴリーに合致するものだけをフィルタリングする「絞り込み検索」の様な形で表示する画面も実装しています。

### 1-1. 画面キャプチャ

__【No.1】__

<img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/sample_screen1.png" width="300"> <img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/sample_screen2.png" width="300">

__【No.2】__

<img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/sample_screen3.png" width="300"> <img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/main/images/sample_screen4.png" width="300">

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

WIP

### 3-1. 全体像の概略図

### 3-2. Middlewareで実行する処理と各種機能とのつながり

### 3-3. API通信部分と内部データ保持に関する処理部分の要点

## 4. UI実装や表現に関連するTIPS紹介

WIP

### 4-1. Home画面で利用されているUI表現に関する要点

- [SwiftUIで作る「Drag処理を利用したCarousel型UI」と「Pinterest風GridレイアウトUI」の実装例とポイントまとめ](https://qiita.com/fumiyasac@github/items/b5b313d9807ff858a73c)

### 4-2. GeometryReaderを利用したStretchyHeader表現

### 4-3. 絞り込み検索の様な形を実現するためのポイント

## 5. 擬似BackendサーバーとAPI定義

サンプルアプリ内では、APIモックサーバーから受け取ったJSON形式のレスポンスを画面に表示する処理を実現するために、node.js製の __「json-server」__ を利用して実現しています。（※こちらはTypeScript製のものを利用しています。）

### 5-1. サンプルで利用しているAPIエンドポイント



WIP

### 5-2. Mockサーバー環境構築

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
