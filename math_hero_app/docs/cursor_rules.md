
# Flutter + SQLite コーディング規約

このプロジェクトでは [docs/cursor_rules.md](./docs/cursor_rules.md) に沿って開発を行います。

## 📦 前提条件

このプロジェクトは以下の技術スタックで構築されています：

- Flutter 3.22+
- Dart 3+
- SQLite（sqflite + path_provider）
- ローカル通知（flutter_local_notifications）
- 状態管理（今後：provider 予定）

## 📁 ディレクトリ構成ルール

```
math-hero-app/
├── lib/
│   ├── models/         # データ構造（Child, Item など）
│   ├── db/             # SQLite接続・DB操作
│   ├── screens/        # 各画面（ホーム・設定・持ち物など）
│   ├── widgets/        # 共通UIパーツ
│   ├── utils/          # 汎用関数や定数
│   └── main.dart       # アプリエントリポイント
├── test/               # 単体テスト
```

## 🧑‍💻 基本コーディング規約

### 型安全性

- null safety は必須
- `late` / nullable 型の使用は最小限に
- `any` の使用は禁止（Dartでは通常不要）
- モデルクラスでは `fromMap` / `toMap` を必ず実装

### 命名規則

| 要素 | 命名例 | 備考 |
|------|--------|------|
| クラス名 | `Child`, `ItemListScreen` | PascalCase |
| ファイル名 | `child.dart`, `item_list_screen.dart` | snake_case |
| メソッド・変数名 | `getAllChildren`, `childList` | lowerCamelCase |
| 定数 | `kDefaultPadding` | `k`プレフィックス + UpperCamelCase（慣例） |

### UI構築

- `StatelessWidget` / `StatefulWidget` を適切に使い分け
- `Scaffold` + `AppBar` + `body` を基本とする構造
- UI構成要素（カード・リスト・フォームなど）は可能な限り `widgets/` に分離
- レスポンシブ対応は今後考慮（スマホ中心）

### データアクセス・状態管理

- DBアクセスは `DatabaseHelper` 経由で統一
- データ構造の変換は `models/` に責任を持たせる
- 画面での状態保持には将来的に `provider` を導入予定（現状は `setState`）

## 🔔 通知機能の設計

- 通知は `flutter_local_notifications` を使用
- 通知設定（ON/OFF・時刻）は `shared_preferences` に保存
- 通知の文面は毎朝DBから取得した持ち物一覧に基づいて動的生成

## 🧪 テストと保守

- 単体テストは `test/` 以下に配置
- モデル、DB処理、通知ロジック、ユーティリティ関数を中心にテスト
- テストには `flutter_test` パッケージを使用
- 将来的には `mockito` または `mocktail` によるモックテストも導入予定
- テスト実行コマンド：

```
flutter test
```

- 開発中は以下も活用：
  - `flutter analyze`
  - `flutter format .`
  - `dart test`（必要に応じて）

## 🛡 エラーハンドリング

- DB・通知処理では `try-catch` を使い、エラー時はログ＋ユーザーへのフォールバック表示
- `print` の使用は開発時に限定し、将来的に `logger` パッケージ導入も検討

## 📝 コーディングスタイル

- 2スペースインデント
- `dart format` を保存時に自動適用
- コメントは日本語でもOK。ただし簡潔かつ「なぜ」を書く
- ネストは3段階程度までを推奨。それ以上は関数抽出を検討すること
- 1行が120文字を超える場合は改行して可読性を保つこと

## ⚙️ コーディング規則

### 変数と定数

1. マジックナンバーは使用しないこと
   - すべての数値は意味のある定数名を付けて定義すること
   - 例外: 配列のインデックス0や1など、明らかな意味を持つ数値

2. 定数を適切に使用すること
   - 複数の場所で使用される値は定数として定義すること
   - 定数名は大文字のスネークケースで定義すること（例: `MAX_RETRY_COUNT`）

3. 一度しか使用しない変数は定義しないこと
   - インライン処理を優先し、コードの簡潔さを維持すること
   - 例外: コードの読みやすさが著しく低下する場合

### テスト容易性

4. 実装した関数やクラスは単体テストしやすいように実装すること
   - 依存性を最小限に抑え、依存性注入パターンを使用すること
   - 副作用を最小限に抑えること
   - 関数は単一責任の原則に従うこと
   - テスト可能なインターフェースを提供すること

### デザインパターンの活用

5. 適切な場面でGoFのデザインパターンを活用すること
   - 例：
     - 状態管理：`Provider` + `ChangeNotifier`（Observerパターン）
     - データアクセス：`Repository` パターンでDBとUIを分離
     - 条件による処理切替：Strategyパターン（例：通知戦略）
     - 画面遷移・依存関係の整理：FactoryパターンやService Locatorの検討
   - 冗長にならない範囲で柔軟に適用し、必要に応じてコメントで意図を明記すること


## Cursor 実装時の追加指示事項

- コーディングルールはこの `cursor_rules.md` に従うこと
- デザインは `docs/design-guidelines.md` を参照すること
- コードの変更が要件に関わる場合は `docs/requirements.md` を更新すること
- 可能な限りテストを追加・修正すること
- ファイル構成・命名規則に一貫性を持たせること
- UIを伴う場合、可能であればスクリーンショットをPRに含めること
