# SwiftUIAndReduxExample
[ING] - SwiftUIとReduxで作るサンプルアプリ

SwiftUIとReduxを組み合わせたUI実装サンプルになります。
基本的には、APIからのデータ取得＆表示やLocalのDBへのデータ登録処理等をする形となっています。

## 1. サンプル概要

WIP

### 1-1. 画面キャプチャ

<img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/master/images/sample_screen1.png" width="393"> <img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/master/images/sample_screen2.png" width="393">

<img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/master/images/sample_screen3.png" width="393"> <img src="https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/master/images/sample_screen4.png" width="393">

## 2. ReduxをSwiftUI画面に導入するにあたって

WIP

### 参考資料

- [Composable SwiftUI Architecture Using Redux ※Udemy講座](https://www.udemy.com/course/composable-swiftui-architecture-using-redux/)
- [Redux入門 〜iOSアプリをReduxで作ってみた〜](https://creators-note.chatwork.com/entry/2021/05/20/100000)
- [取り組んだ講座の要点をまとめたノート](https://twitter.com/fumiyasac/status/1582883611681861632)
- [](https://qiita.com/fumiyasac@github/items/f25465a955afdcb795a2)

## 3. このサンプル実装におけるアーキテクチャ

WIP

## 4. UI実装や表現に関連するTIPS紹介

WIP

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

![各種画面に関する構想やasync/awaitを利用した並列処理に関連するメモ](https://github.com/fumiyasac/SwiftUIAndReduxExample/blob/master/images/design_memo.png)
