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


# 内部スクリプト / パッチ構成

`autounattend.xml` 内には、Windows Setup中に展開される複数の
PowerShell / XML スクリプトが含まれています。

これらはWindowsセットアップの各フェーズで実行され、
不要コンポーネントの削除、ユーザー設定、Windows Update設定、
初回ログオン処理などを担当します。

---

## RemovePackages.ps1

Windowsにプロビジョニングされている不要なAppxパッケージを削除します。

対象例：

- 3D Viewer
- Bing Search
- Windows Camera
- Clipchamp
- Alarms
- Dev Home
- Feedback Hub
- Get Help
- Maps
- Mixed Reality Portal
- Outlook for Windows
- Paint
- People
- Photos
- Power Automate Desktop
- Quick Assist
- Skype
- Snipping Tool
- Solitaire
- Sticky Notes
- Teams
- To Do
- Sound Recorder
- Weather
- Windows Terminal
- Phone Link
- Movies & TV

など。

内部では、

`Get-AppxProvisionedPackage -Online`

でWindowsイメージに登録されているパッケージを取得し、

`Remove-AppxProvisionedPackage -AllUsers -Online`

によって削除します。

処理結果は以下へ記録されます。

`C:\Windows\Setup\Scripts\RemovePackages.log`

> 注意  
> Windows UpdateやMicrosoft Storeによって、
> 後から再インストールされるアプリが存在する場合があります。

---

## RemoveCapabilities.ps1

Windows Capabilityとして実装されている追加機能を削除します。

対象：

- Fax / Scan関連
- Handwriting
- Math Recognizer
- OneSync
- Paint
- PowerShell ISE
- Quick Assist
- Snipping Tool
- Speech
- Text To Speech
- Steps Recorder
- WordPad

など。

Windows Capabilityを、

`Get-WindowsCapability -Online`

で取得し、

`Remove-WindowsCapability -Online`

で削除します。

ログ：

`C:\Windows\Setup\Scripts\RemoveCapabilities.log`

---

## RemoveFeatures.ps1

Windows Optional Featureを無効化・削除します。

対象：

- Media Playback
- Remote Desktop Connection
- Recall
- Snipping Tool

など。

内部では、

`Get-WindowsOptionalFeature -Online`

で対象機能を確認し、

`Disable-WindowsOptionalFeature -Online -Remove`

で機能を無効化します。

ログ：

`C:\Windows\Setup\Scripts\RemoveFeatures.log`

---

## Specialize.ps1

Windows Setupの `specialize` フェーズで実行される
メインのシステム構成スクリプトです。

主な処理：

- OOBE Network Requirementの回避
- 不要Windowsアプリ・Capability・Featureの削除
- OneDrive Setupファイルの削除
- Outlook / Dev Home自動セットアップ抑止
- Chat自動インストール抑止
- Wi-Fiプロファイル登録
- Wi-Fi自動接続
- ローカルパスワードの有効期限を無期限化
- Windows Update設定
- 自動再起動抑止
- Windows Update Active Hours設定
- Fast Startup無効化
- Widgets / News and Interests無効化
- Windows視覚効果の軽量化
- Sticky Keys設定
- BitLocker / Device Encryption自動有効化抑止
- 日本語システムロケール設定

また、

- `RemovePackages.ps1`
- `RemoveCapabilities.ps1`
- `RemoveFeatures.ps1`

をここから順番に呼び出します。

ログ：

`C:\Windows\Setup\Scripts\Specialize.log`

