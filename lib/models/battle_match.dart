/// 対戦マッチの情報を管理するモデルクラス
class BattleMatch {
  final int? id;
  final String player1Name;
  final String player2Name;
  final int player1Score;
  final int player2Score;
  final String winner;
  final DateTime createdAt;

  const BattleMatch({
    this.id,
    required this.player1Name,
    required this.player2Name,
    required this.player1Score,
    required this.player2Score,
    required this.winner,
    required this.createdAt,
  });

  /// MapからBattleMatchオブジェクトを作成
  factory BattleMatch.fromMap(Map<String, dynamic> map) {
    return BattleMatch(
      id: map['id'] as int?,
      player1Name: map['player1_name'] as String,
      player2Name: map['player2_name'] as String,
      player1Score: map['player1_score'] as int,
      player2Score: map['player2_score'] as int,
      winner: map['winner'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// BattleMatchオブジェクトをMapに変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'player1_name': player1Name,
      'player2_name': player2Name,
      'player1_score': player1Score,
      'player2_score': player2Score,
      'winner': winner,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// 勝者を判定
  String getWinner() {
    if (player1Score > player2Score) {
      return player1Name;
    } else if (player2Score > player1Score) {
      return player2Name;
    } else {
      return '引き分け';
    }
  }

  /// 新しいBattleMatchオブジェクトを作成（IDなし）
  BattleMatch copyWith({
    int? id,
    String? player1Name,
    String? player2Name,
    int? player1Score,
    int? player2Score,
    String? winner,
    DateTime? createdAt,
  }) {
    return BattleMatch(
      id: id ?? this.id,
      player1Name: player1Name ?? this.player1Name,
      player2Name: player2Name ?? this.player2Name,
      player1Score: player1Score ?? this.player1Score,
      player2Score: player2Score ?? this.player2Score,
      winner: winner ?? this.winner,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
