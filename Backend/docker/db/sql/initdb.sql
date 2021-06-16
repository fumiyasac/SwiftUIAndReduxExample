/**
 * データベースの新規作成用のSQL
 */
create database swiftui_redux_sample;
create database test_swiftui_redux_sample;

/**
 * 新規作成したデータベースに対してアクセス権限を付与する
 */
grant all on swiftui_redux_sample.* to 'just1factory'@'%';
grant all on test_swiftui_redux_sample.* to 'just1factory'@'%';
