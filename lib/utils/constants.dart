/// アプリ全体で使用する定数
class AppConstants {
  // プライバシーコンストラクタ
  AppConstants._();

  // スペーシング
  static const double kSpacing4 = 4.0;
  static const double kSpacing8 = 8.0;
  static const double kSpacing12 = 12.0;
  static const double kSpacing16 = 16.0;
  static const double kSpacing24 = 24.0;
  static const double kSpacing32 = 32.0;

  // ボーダー半径
  static const double kBorderRadius8 = 8.0;
  static const double kBorderRadius12 = 12.0;

  // カラーパレット
  static const int kPrimaryLight = 0xFF64B5F6;
  static const int kPrimary = 0xFF2196F3;
  static const int kPrimaryDark = 0xFF1976D2;

  static const int kSecondaryLight = 0xFFFFE082;
  static const int kSecondary = 0xFFFFC107;
  static const int kSecondaryDark = 0xFFFFA000;

  static const int kSuccess = 0xFF66BB6A;
  static const int kWarning = 0xFFFFB74D;
  static const int kError = 0xFFEF5350;

  // ゲーム設定
  static const int kDefaultTimeLimit = 60; // 秒
  static const int kMaxQuestions = 100;
  static const int kMinNumber = 1;
  static const int kMaxNumber = 20;

  // 計算問題設定
  static const int kMaxOperand = 99;
  static const int kMinOperand = 1;
  static const int kMaxAnswer = 999;
  static const int kChoiceCount = 4;

  // データベース
  static const String kDatabaseName = 'math_hero.db';
  static const int kDatabaseVersion = 1;

  // 通知設定
  static const String kNotificationChannelId = 'math_hero_notifications';
  static const String kNotificationChannelName = 'マスヒーロー通知';
  static const String kNotificationChannelDescription = '計算ゲームの通知';
}
