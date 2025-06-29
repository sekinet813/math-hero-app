# マスヒーロー (Math Hero)

小学生向けの楽しい計算ゲームアプリです。

## 概要

マスヒーローは、小学生が楽しく計算力を身につけられるFlutterアプリです。YouTube視聴の代替として、保護者が安心して子どもに与えられる学習アプリを目指しています。

## 機能

- 計算カテゴリ選択（足し算、引き算など）
- ゲームモード選択（タイムアタック、エンドレス）
- スコア記録と履歴表示
- 完全オフライン動作

## 技術スタック

- Flutter 3.22+
- Dart 3+
- SQLite（sqflite + path_provider）
- Provider（状態管理）
- ローカル通知（flutter_local_notifications）

## 開発環境セットアップ

### 前提条件

- Flutter 3.22以上
- Dart 3以上
- Android Studio / VS Code

### セットアップ手順

1. リポジトリをクローン
```bash
git clone <repository-url>
cd math-hero-app
```

2. 依存関係をインストール
```bash
flutter pub get
```

3. アプリを実行
```bash
flutter run
```

## プロジェクト構造

```bash
# リポジトリをクローン
git clone https://github.com/your-username/math-hero.git

# ディレクトリに移動
cd math-hero

# 必要パッケージを取得
flutter pub get

# エミュレーターまたはデバイスで起動
flutter run
```
