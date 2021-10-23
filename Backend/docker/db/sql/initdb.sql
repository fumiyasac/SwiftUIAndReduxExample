/**
 * データベースの新規作成用のSQL
 */
create database swiftui_and_redux_example;
create database test_swiftui_and_redux_example;

/**
 * 新規作成したデータベースに対してアクセス権限を付与する
 */
grant all on swiftui_and_redux_example.* to 'just1factory'@'%';
grant all on test_swiftui_and_redux_example.* to 'just1factory'@'%';
