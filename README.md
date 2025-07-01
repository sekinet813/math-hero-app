# マスヒーロー (Math Hero)

小学生向けの楽しい計算ゲームアプリです。

## 概要

マスヒーローは、小学生が楽しく計算力を身につけられるFlutterアプリです。YouTube視聴の代替として、保護者が安心して子どもに与えられる学習アプリを目指しています。

## 機能

- 計算カテゴリ選択（足し算、引き算、掛け算、割り算）
- ゲームモード選択（タイムアタック、エンドレス）
- スコア記録と履歴表示
- **親子対戦モード** - 親と子どもがご褒美券を賭けて対戦
- **ご褒美券システム** - 勝者の券を表示し、履歴で管理
- 完全オフライン動作

## 新機能（v1.1.0）

### 親子対戦モード
- 親と子どもがそれぞれご褒美券を選択
- 対戦結果に応じて勝者の券を表示
- キラキラ演出で勝利を祝福

### ご褒美券システム
- プリセットのご褒美券（親用・子用）
- 対戦履歴のSQLite保存
- 履歴画面での使用済み管理

## 技術スタック

- Flutter 3.32+
- Dart 3.8+
- SQLite（sqflite + path_provider）
- Provider（状態管理）
- ローカル通知（flutter_local_notifications）

## 開発環境セットアップ

### 前提条件

- Flutter 3.32以上
- Dart 3.8以上
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

```
lib/
├── models/          # データモデル（MathProblem, RewardTicket等）
├── providers/       # 状態管理（GameProvider）
├── screens/         # 画面（HomeScreen, GamePlayScreen等）
├── utils/           # ユーティリティ（問題生成、DB操作等）
└── widgets/         # 再利用可能なウィジェット
```

## テスト

```bash
# 全テスト実行
flutter test

# 特定のテストファイル実行
flutter test test/models/math_problem_test.dart
```

## ビルド

```bash
# Android APK
flutter build apk

# iOS
flutter build ios
```
