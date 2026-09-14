# Windows Autounattend

Windows 11 の自動インストール / キッティング用 `autounattend.xml`。

## 主な設定
- ローカルユーザー `user` を実利用アカウントとして使用
- `user` を Administrators に所属
- 余計な `Admin` アカウントを作成しない
- 日本語 UI / ja-JP / 日本語入力設定
- JIS 106/109 キーボード向け設定
- BitLocker / Device Encryption の自動有効化を抑止
- 隠しファイル / 保護されたOSファイルを通常どおり非表示
- Windows 11 の一部要件チェック回避
- 不要アプリ・機能の削除や初期設定

## 使い方
1. `autounattend.xml` 内の `YOUR_WIFI_SSID` と `YOUR_WIFI_PASSWORD` を対象環境に合わせて設定する。
2. Windows ISO またはインストールUSBのルートへ `autounattend.xml` を配置する。
3. Windows Setup を起動する。

## セキュリティ上の注意
Wi-Fi パスワードなどの認証情報は Git にコミットしないでください。
公開リポジトリでは必ずプレースホルダーのまま管理します。

##　インストール時の注意点
Ventoyを利用してインストールする場合が想定されるため、インストール先のディスク及びパーティションの指定に関しては
人間が行うことを想定している。

## scripts
- `remove_desktop_ini.cmd` / `.ps1`
  - デスクトップ上の `desktop.ini` を削除
- `user_only_cleanup.cmd` / `.ps1`
  - 既存環境を `user` 一本運用に寄せる補助スクリプト
