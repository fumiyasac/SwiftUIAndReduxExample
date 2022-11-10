# SwiftUIAndReduxExample
[ING] - SwiftUIとReduxで作るサンプルアプリ

SwiftUIとReduxを組み合わせたUI実装サンプルになります。
基本的には、APIからのデータ取得＆表示やLocalのDBへのデータ登録処理等をする形となっています。

※ Backend側はTypeScript製の「json-server」で動作させています。

### 参考資料

__【Reduxに関する基本事項の整理】__

- [Composable SwiftUI Architecture Using Redux ※Udemy講座](https://www.udemy.com/course/composable-swiftui-architecture-using-redux/)
- [取り組んだ講座の要点をまとめたノート](https://twitter.com/fumiyasac/status/1582883611681861632)


__【Mockサーバー環境構築】__

このリポジトリをClone後に下記コマンドを実行することで、自分のローカル環境で動作させる事ができます。

```shell
# 必要なpackageのインストール
$ yarn install
# Mockサーバーの実行
$ yarn start
```

※ 自分の手元でまっさらな状態から準備する場合は下記コマンドを順次実行するイメージになります。

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

```json
{
  "name": "mock_server",
  "version": "1.0.0",
  "main": "index.js",
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

- [json-serverの実装に関する参考資料](https://blog.eleven-labs.com/en/json-server)
- [TypeScriptで始めるNode.js入門](https://ics.media/entry/4682/)
- [JSON ServerをCLIコマンドを使わずTypescript＆node.jsからサーバーを立てるやり方](https://deep.tacoskingdom.com/blog/151)

