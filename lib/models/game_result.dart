/// ゲーム結果を管理するモデルクラス
class GameResult {
  final int? id;
  final int playerId;
  final String category;
  final String gameMode;
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final Duration playTime;
  final DateTime playedAt;

  const GameResult({
    this.id,
    required this.playerId,
    required this.category,
    required this.gameMode,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.playTime,
    required this.playedAt,
  });

  /// MapからGameResultオブジェクトを作成
  factory GameResult.fromMap(Map<String, dynamic> map) {
    return GameResult(
      id: map['id'] as int?,
      playerId: map['player_id'] as int,
      category: map['category'] as String,
      gameMode: map['game_mode'] as String,
      score: map['score'] as int,
      correctAnswers: map['correct_answers'] as int,
      totalQuestions: map['total_questions'] as int,
      playTime: Duration(milliseconds: map['play_time_ms'] as int),
      playedAt: DateTime.parse(map['played_at'] as String),
    );
  }

  /// GameResultオブジェクトをMapに変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'player_id': playerId,
      'category': category,
      'game_mode': gameMode,
      'score': score,
      'correct_answers': correctAnswers,
      'total_questions': totalQuestions,
      'play_time_ms': playTime.inMilliseconds,
      'played_at': playedAt.toIso8601String(),
    };
  }

  /// 正答率を計算
  double get accuracyRate {
    if (totalQuestions == 0) return 0.0;
    return (correctAnswers / totalQuestions) * 100;
  }
}
