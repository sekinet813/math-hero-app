# UI/UXデザイン指針（マスヒーロー）

このドキュメントは、小学生向け計算ゲームアプリ **マスヒーロー（Math Hero）** の
Flutter UI/UX設計における指針と Material Design 3 (Material You) を取り入れたテーマ設計ガイドラインです。

---

## 目的

小学生が楽しく安全にスマホで学べるように、Material Design の信頼性と
子ども向けの親しみやすさを両立すること。  
保護者が安心して「YouTube代わり」に与えられるUI/UXを実現する。

---

## デザイン原則

- Googleの Material Design 3 に準拠
- 子どもが迷わないシンプルな操作
- 達成感・ゲーム感を演出する色とアニメーション
- 色覚バリアフリーも考慮した配色

---

## カラーパレット（ColorScheme）

- **メインカラー**：元気なブルー系（seedColor）
- **アクセントカラー**：明るいオレンジ系
- **背景色**：ホワイト or ライトグレー
- **テキスト**：ダークグレー

```dart
// 色定義
static const Color kPrimaryLight = Color(0xFF64B5F6);
static const Color kPrimary      = Color(0xFF2196F3);
static const Color kPrimaryDark  = Color(0xFF1976D2);

static const Color kSecondaryLight = Color(0xFFFFE082);
static const Color kSecondary      = Color(0xFFFFC107);
static const Color kSecondaryDark  = Color(0xFFFFA000);

static const Color kSuccess = Color(0xFF66BB6A);
static const Color kWarning = Color(0xFFFFB74D);
static const Color kError   = Color(0xFFEF5350);
```

```dart
final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: kPrimary,
  brightness: Brightness.light,
);
```

---

## レイアウト指針

- **8dp Grid System**
- カード：BorderRadius 12dp, Elevation 2-4dp
- ボタン：Rounded corners, Filled/Outlined を使い分ける

```dart
// スペーシング
static const double kSpacing8  = 8.0;
static const double kSpacing16 = 16.0;
static const double kSpacing24 = 24.0;
static const double kSpacing32 = 32.0;
```

---

## タイポグラフィ

- Material 3 標準の Typography をベースに
- 子どもに読みやすい大きさに調整

```dart
textTheme: Typography.blackMountainView,
```

- Display Large：32sp
- Headline Large：28sp
- Body Large：16sp

---

## コンポーネント設計

- `Scaffold` / `NavigationBar` を活用
- `FilledButton`, `OutlinedButton`, `IconButton`
- `SnackBar`, `Dialog` でフィードバック

```dart
filledButtonTheme: FilledButtonThemeData(
  style: FilledButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  ),
),
```

---

## アニメーションとフィードバック

- Duration: 200–400ms
- Curve: `Curves.easeInOut`
- 正解時の Scale / Ripple Effect を適所で

---

## アクセシビリティ

- コントラスト比 4.5:1 以上
- タッチターゲット 48dp 以上
- フォントサイズ 14sp 以上

---

## ダークモード対応

```dart
static const Color kSurfaceLight = Color(0xFFFFFFFF);
static const Color kOnSurfaceLight = Color(0xFF1C1B1F);

static const Color kSurfaceDark = Color(0xFF1C1B1F);
static const Color kOnSurfaceDark = Color(0xFFE6E1E5);
```

- システムテーマに追従、将来的に手動切り替えを検討

---

## 実装例（Material 3）

```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: Typography.blackMountainView,
  ),
);
```

---

このガイドラインはマスヒーローの UI/UX 開発の共通理解として活用し、
必要に応じて更新していきます。
