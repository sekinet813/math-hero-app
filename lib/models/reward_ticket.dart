/// ご褒美券モデル
class RewardTicket {
  /// 券の一意なID
  final String id;

  /// 券の表示名
  final String name;

  /// 券の説明
  final String description;

  /// アイコンのアセットパス
  final String iconPath;

  /// 対象（parent/child）
  final String target;

  /// 拡張用フィールド（将来のカスタム券用）
  final Map<String, dynamic>? extra;

  RewardTicket({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.target,
    this.extra,
  });
}
