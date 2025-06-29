import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/models/game_result.dart';

void main() {
  group('GameResult Model Tests', () {
    test('fromMapでGameResultオブジェクトが正しく作成される', () {
      final map = {
        'id': 1,
        'player_id': 1,
        'category': 'addition',
        'game_mode': 'time_attack',
        'score': 100,
        'correct_answers': 8,
        'total_questions': 10,
        'play_time_ms': 60000,
        'played_at': '2024-01-01T00:00:00.000Z',
      };

      final gameResult = GameResult.fromMap(map);

      expect(gameResult.id, 1);
      expect(gameResult.playerId, 1);
      expect(gameResult.category, 'addition');
      expect(gameResult.gameMode, 'time_attack');
      expect(gameResult.score, 100);
      expect(gameResult.correctAnswers, 8);
      expect(gameResult.totalQuestions, 10);
      expect(gameResult.playTime.inMilliseconds, 60000);
      expect(gameResult.playedAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
    });

    test('toMapでMapが正しく作成される', () {
      final gameResult = GameResult(
        id: 1,
        playerId: 1,
        category: 'addition',
        gameMode: 'time_attack',
        score: 100,
        correctAnswers: 8,
        totalQuestions: 10,
        playTime: const Duration(minutes: 1),
        playedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      final map = gameResult.toMap();

      expect(map['id'], 1);
      expect(map['player_id'], 1);
      expect(map['category'], 'addition');
      expect(map['game_mode'], 'time_attack');
      expect(map['score'], 100);
      expect(map['correct_answers'], 8);
      expect(map['total_questions'], 10);
      expect(map['play_time_ms'], 60000);
      expect(map['played_at'], '2024-01-01T00:00:00.000Z');
    });

    test('accuracyRateが正しく計算される', () {
      final gameResult = GameResult(
        playerId: 1,
        category: 'addition',
        gameMode: 'time_attack',
        score: 100,
        correctAnswers: 8,
        totalQuestions: 10,
        playTime: const Duration(minutes: 1),
        playedAt: DateTime.now(),
      );

      expect(gameResult.accuracyRate, 80.0);
    });

    test('totalQuestionsが0の場合、accuracyRateは0を返す', () {
      final gameResult = GameResult(
        playerId: 1,
        category: 'addition',
        gameMode: 'time_attack',
        score: 0,
        correctAnswers: 0,
        totalQuestions: 0,
        playTime: const Duration(minutes: 1),
        playedAt: DateTime.now(),
      );

      expect(gameResult.accuracyRate, 0.0);
    });

    test('完全正解の場合、accuracyRateは100を返す', () {
      final gameResult = GameResult(
        playerId: 1,
        category: 'addition',
        gameMode: 'time_attack',
        score: 100,
        correctAnswers: 10,
        totalQuestions: 10,
        playTime: const Duration(minutes: 1),
        playedAt: DateTime.now(),
      );

      expect(gameResult.accuracyRate, 100.0);
    });
  });
}
