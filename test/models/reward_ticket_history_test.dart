import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/models/reward_ticket_history.dart';

void main() {
  group('RewardTicketHistory', () {
    test('should create a history with required fields', () {
      final playedAt = DateTime(2024, 1, 1, 12, 0, 0);
      final history = RewardTicketHistory(
        winner: 'parent',
        ticketId: 'test_ticket',
        ticketName: 'テスト券',
        used: false,
        playedAt: playedAt,
      );

      expect(history.id, isNull);
      expect(history.winner, equals('parent'));
      expect(history.ticketId, equals('test_ticket'));
      expect(history.ticketName, equals('テスト券'));
      expect(history.used, isFalse);
      expect(history.playedAt, equals(playedAt));
      expect(history.usedAt, isNull);
    });

    test('should create a history with used status', () {
      final playedAt = DateTime(2024, 1, 1, 12, 0, 0);
      final usedAt = DateTime(2024, 1, 2, 12, 0, 0);
      final history = RewardTicketHistory(
        id: 1,
        winner: 'child',
        ticketId: 'test_ticket',
        ticketName: 'テスト券',
        used: true,
        playedAt: playedAt,
        usedAt: usedAt,
      );

      expect(history.id, equals(1));
      expect(history.winner, equals('child'));
      expect(history.used, isTrue);
      expect(history.usedAt, equals(usedAt));
    });

    test('should convert to map correctly', () {
      final playedAt = DateTime(2024, 1, 1, 12, 0, 0);
      final usedAt = DateTime(2024, 1, 2, 12, 0, 0);
      final history = RewardTicketHistory(
        id: 1,
        winner: 'parent',
        ticketId: 'test_ticket',
        ticketName: 'テスト券',
        used: true,
        playedAt: playedAt,
        usedAt: usedAt,
      );

      final map = history.toMap();

      expect(map['id'], equals(1));
      expect(map['winner'], equals('parent'));
      expect(map['ticketId'], equals('test_ticket'));
      expect(map['ticketName'], equals('テスト券'));
      expect(map['used'], equals(1));
      expect(map['playedAt'], equals(playedAt.toIso8601String()));
      expect(map['usedAt'], equals(usedAt.toIso8601String()));
    });

    test('should create from map correctly', () {
      final playedAt = DateTime(2024, 1, 1, 12, 0, 0);
      final usedAt = DateTime(2024, 1, 2, 12, 0, 0);
      final map = {
        'id': 1,
        'winner': 'child',
        'ticketId': 'test_ticket',
        'ticketName': 'テスト券',
        'used': 1,
        'playedAt': playedAt.toIso8601String(),
        'usedAt': usedAt.toIso8601String(),
      };

      final history = RewardTicketHistory.fromMap(map);

      expect(history.id, equals(1));
      expect(history.winner, equals('child'));
      expect(history.ticketId, equals('test_ticket'));
      expect(history.ticketName, equals('テスト券'));
      expect(history.used, isTrue);
      expect(history.playedAt, equals(playedAt));
      expect(history.usedAt, equals(usedAt));
    });

    test('should handle unused ticket correctly', () {
      final playedAt = DateTime(2024, 1, 1, 12, 0, 0);
      final map = {
        'id': 1,
        'winner': 'parent',
        'ticketId': 'test_ticket',
        'ticketName': 'テスト券',
        'used': 0,
        'playedAt': playedAt.toIso8601String(),
        'usedAt': null,
      };

      final history = RewardTicketHistory.fromMap(map);

      expect(history.used, isFalse);
      expect(history.usedAt, isNull);
    });
  });
}
