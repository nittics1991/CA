# CA

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

## IISへの設定

### Server証明書

1. setting.cnfのServer証明書設定で、CNをサーバのFQDNにし、バッチを実行

2. p12ファイルをダブルクリックし、RootCA,InterCA,Server証明書を、ローカルコンピュータにインポートする

3. certml.mscを開き、個人ディレクトリからServer証明書を削除する

4. IISマネージャのホームで、サーバ証明書-インポートを開き、下記設定でインポートする
    - 証明書ファイル p12ファイル
    - パスワード p12ファイルのパスワード
    - 証明書ストア Webホスティング

5. 対象サイトを選択し、バインドを開き、下記を設定する
    - 種類 https
    - ポート 自動設定(443)または任意
    - SSL証明書 対象とする証明書

7. SSLを開き、下記を設定する
    - SSLが必要 checked
    - クライアント証明書 サーバ証明書のみの場合は無視、クライアント証明書を使用する場合は必要をon

8. サイトを再起動し、ブラウザからhttpsアクセスし、動作を確認する

### Client証明書(サーバ側)

1. setting.cnfのClient証明書設定で、有効期限を設定し、バッチを実行

2. certファイルをエディタで開き、-----BEGIN CERTIFICATE----- と -----END CERTIFICATE-----　の間の文字列をコピー

3. 貼り付けた文字列の改行\nを削除し、1行の文字列とする(以下cert文字列)

4. ローカルユーザとグループ-ユーザを開き、新しいユーザを追加する
    ユーザ名　任意
    パスワード　任意
    ユーザは次回ログオン時にパスワードの変更が必要 off
    パスワードを無期限にする on
    所属グループ　(ローカルPC)\Guests 追加

5. IIS機能にIISクライアント認証マッピング認証を追加

6. IISマネージャで対象サイトを選択し、構成エディタで下記を開く
    - system.webServer/security/authentication/iisClientCertificateMappingAuthentication

7. IISクライアント認証マッピング認証にて下記を設定する
    - enabled true
    - oneToOneCertificateMappings true
    - oneToOneMappings　を開き、下記を追加する
        - certificate cert文字列
        - userName 新規追加ユーザ
        - password 新規追加ユーザのパスワード

8. SSLを開き、下記を設定する
    - クライアント証明書 必要 on

9. 認証を開き、下記を設定する
    - 匿名認証 無効化

10. 失敗した要求トレースの規則を開き、下記を設定する
    - 403.7を除外

11. サイトを再起動する

### Client証明書(クライアント側)

1. p12ファイルをダブルクリックし、RootCA,InterCA,Client証明書を、個人にインポートする

2. ブラウザからhttpsアクセスすると、証明書の選択が表示されるので、インポートしたClient証明書を選択

3. 画面を表示すればOK

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
