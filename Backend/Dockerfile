# -----------
# Goで作成する簡易APIサーバーサンプル
#
# (1) 基本的にはこの構成をベースにして色々やっていく方針
# 参考: https://github.com/fuhiz/docker-go-sample
#
# (2) パッケージやモジュール等に関する基本事項
# 参考: https://blog.framinal.life/entry/2021/04/11/013819
# -----------

# 利用するGolangのバージョン指定
FROM golang:1.16.3-alpine

# 実際にアプリケーションを動作させるディレクトリ
WORKDIR /app

# Golangのモジュールのパスを記載するファイル
COPY app/go.mod .

# Golangの依存モジュールのチェックサムを記載するファイル
COPY app/go.sum .

# 外部依存パッケージのダウンロードを実行する
RUN go mod download

# 8080番ポートで実行する
EXPOSE 8080
