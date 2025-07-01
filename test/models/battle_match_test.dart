import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/models/battle_match.dart';

void main() {
  group('BattleMatch', () {
    test('fromMap should create BattleMatch correctly', () {
      final map = {
        'id': 1,
        'player1_name': '太郎',
        'player2_name': '花子',
        'player1_score': 3,
        'player2_score': 2,
        'winner': '太郎',
        'created_at': '2024-01-01T12:00:00.000Z',
      };

      final battleMatch = BattleMatch.fromMap(map);

      expect(battleMatch.id, 1);
      expect(battleMatch.player1Name, '太郎');
      expect(battleMatch.player2Name, '花子');
      expect(battleMatch.player1Score, 3);
      expect(battleMatch.player2Score, 2);
      expect(battleMatch.winner, '太郎');
      expect(battleMatch.createdAt, DateTime.parse('2024-01-01T12:00:00.000Z'));
    });

    test('toMap should convert BattleMatch to map correctly', () {
      final createdAt = DateTime.now();
      final battleMatch = BattleMatch(
        id: 1,
        player1Name: '太郎',
        player2Name: '花子',
        player1Score: 3,
        player2Score: 2,
        winner: '太郎',
        createdAt: createdAt,
      );

      final map = battleMatch.toMap();

      expect(map['id'], 1);
      expect(map['player1_name'], '太郎');
      expect(map['player2_name'], '花子');
      expect(map['player1_score'], 3);
      expect(map['player2_score'], 2);
      expect(map['winner'], '太郎');
      expect(map['created_at'], createdAt.toIso8601String());
    });

    test('getWinner should return correct winner', () {
      // プレイヤー1が勝つ場合
      var battleMatch = BattleMatch(
        player1Name: '太郎',
        player2Name: '花子',
        player1Score: 3,
        player2Score: 2,
        winner: '太郎',
        createdAt: DateTime.now(),
      );
      expect(battleMatch.getWinner(), '太郎');

      // プレイヤー2が勝つ場合
      battleMatch = BattleMatch(
        player1Name: '太郎',
        player2Name: '花子',
        player1Score: 2,
        player2Score: 3,
        winner: '花子',
        createdAt: DateTime.now(),
      );
      expect(battleMatch.getWinner(), '花子');

      // 引き分けの場合
      battleMatch = BattleMatch(
        player1Name: '太郎',
        player2Name: '花子',
        player1Score: 3,
        player2Score: 3,
        winner: '引き分け',
        createdAt: DateTime.now(),
      );
      expect(battleMatch.getWinner(), '引き分け');
    });

    test('copyWith should create new instance with updated values', () {
      final original = BattleMatch(
        id: 1,
        player1Name: '太郎',
        player2Name: '花子',
        player1Score: 3,
        player2Score: 2,
        winner: '太郎',
        createdAt: DateTime.now(),
      );

      final updated = original.copyWith(
        player1Score: 4,
        player2Score: 1,
        winner: '太郎',
      );

      expect(updated.id, original.id);
      expect(updated.player1Name, original.player1Name);
      expect(updated.player2Name, original.player2Name);
      expect(updated.player1Score, 4);
      expect(updated.player2Score, 1);
      expect(updated.winner, '太郎');
      expect(updated.createdAt, original.createdAt);
    });
  });
}
