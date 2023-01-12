// ⭐️参考: json-serverの実装に関する参考資料
// https://blog.eleven-labs.com/en/json-server
// ⭐️関連1: TypeScriptで始めるNode.js入門
// https://ics.media/entry/4682/
// ⭐️関連2: JSON ServerをCLIコマンドを使わずTypescript＆node.jsからサーバーを立てるやり方
// https://deep.tacoskingdom.com/blog/151

// Mock用のJSONレスポンスサーバーの初期化設定
import jsonServer from 'json-server';
const server = jsonServer.create();

// Database構築用のJSONファイル
const router = jsonServer.router('db/db.json');

// 各種設定用
const middlewares = jsonServer.defaults();
// リライトルールを設定する
const rewrite_rules = jsonServer.rewriter({
    // Home画面で利用するエンドポイント
    "/api/v1/campaign_banners" : "/get_campaign_banners",
    "/api/v1/recent_news" : "/get_recent_news",
    "/api/v1/featured_topics" : "/get_featured_topics",
    "/api/v1/trend_articles" : "/get_trend_articles",
    "/api/v1/pickup_photos" : "/get_pickup_photos",
    // Favorite画面で利用するエンドポイント
    "/api/v1/favorite_scenes" : "/get_favorite_scenes",
    // Archive画面で利用するエンドポイント
    "/api/v1/achive_images" : "/get_achive_images"
});
// リクエストのルールを設定する
server.use(rewrite_rules);

// ミドルウェアを設定する (※コンソール出力するロガーやキャッシュの設定等)
server.use(middlewares);

// ルーティングを設定する
server.use(router);

// サーバをポート3000で起動する
server.listen(3000, () => {
    console.log('SwiftUIAndReduxExample Mock Server is running...');
});
