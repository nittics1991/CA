# CA

## 注意

apacheでにClient証明書動作はテスト未完了

## 使用方法

- 設定ファイル設定
    - setting.cnf
    - ファイル名や有効期限など定義

- 初期ディレクトリ/設定値ファイル作成
    - createFolder.sh
    - 自己PKI構築時に1回のみ実行

- RootCA構築
    - newRootCa.sh
    - 基本的には1回発行すればOK

- InterMediateCA構築
    - newInterCa.sh
    - 基本的には1回発行すればOK

- Server証明書発行
    - newServer.sh
    - 基本的には1回発行すればOK

- Client証明書発行
    - newClient.sh
    - 1年程度を目処に発行

- ディレクトリ削除
    - cleanFolder.sh

- RootCaにて証明書失効
    - revokeRootCa.sh 失効対象証明書ファイル (PATHなし)

- InterCaにて証明書失効
    - revokeInterCa.sh 失効対象証明書ファイル (PATHなし)


## 参考資料

[openssl docs](https://www.openssl.org/docs/manmaster/)

[openssl コマンド説明/quita](https://qiita.com/hana_shin/items/6d9de0847a06d8ee95cc)

[openssl コマンド説明/分類](http://x68000.q-e-d.net/~68user/unix/pickup?openssl)

[暗号技術](https://sehermitage.web.fc2.com/crypto.html)

[usr_certについての資料](https://blog.goo.ne.jp/espiya/e/57a81a67c1a1c035d949f09b672ed6ba)

[sample](https://oxynotes.com/?p=4516)

[丁寧な説明](https://qiita.com/3244/items/780469306a3c3051c9fe)

[MS IIS AD client認証](https://docs.microsoft.com/ja-jp/previous-versions/ee431573%28v%3dtechnet.10%29)

[IIS client認証関連](https://help.tableau.com/current/server/ja-jp/ssl_mutual_mapping_username.htm)

[IIS 多対 1 マッピング](https://docs.microsoft.com/ja-jp/previous-versions/ee431621(v=technet.10)?redirectedfrom=MSDN)
