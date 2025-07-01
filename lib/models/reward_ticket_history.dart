/// ご褒美券履歴モデル
class RewardTicketHistory {
  /// 履歴ID（DBの主キー）
  final int? id;

  /// 勝者（parent/child）
  final String winner;

  /// 券ID
  final String ticketId;

  /// 券名
  final String ticketName;

  /// 使用済みかどうか
  final bool used;

  /// 勝負日時
  final DateTime playedAt;

  /// 使用日時（未使用ならnull）
  final DateTime? usedAt;

  RewardTicketHistory({
    this.id,
    required this.winner,
    required this.ticketId,
    required this.ticketName,
    required this.used,
    required this.playedAt,
    this.usedAt,
  });

  /// DB保存用Map変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'winner': winner,
      'ticketId': ticketId,
      'ticketName': ticketName,
      'used': used ? 1 : 0,
      'playedAt': playedAt.toIso8601String(),
      'usedAt': usedAt?.toIso8601String(),
    };
  }

  /// DBからの生成
  factory RewardTicketHistory.fromMap(Map<String, dynamic> map) {
    return RewardTicketHistory(
      id: map['id'] as int?,
      winner: map['winner'] as String,
      ticketId: map['ticketId'] as String,
      ticketName: map['ticketName'] as String,
      used: (map['used'] as int) == 1,
      playedAt: DateTime.parse(map['playedAt'] as String),
      usedAt: map['usedAt'] != null
          ? DateTime.parse(map['usedAt'] as String)
          : null,
    );
  }
}
