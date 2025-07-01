import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/models/reward_ticket.dart';

void main() {
  group('RewardTicket', () {
    test('should create a reward ticket with required fields', () {
      final ticket = RewardTicket(
        id: 'test_id',
        name: 'テスト券',
        description: 'テスト用のご褒美券です',
        iconPath: 'assets/icons/test.png',
        target: 'parent',
      );

      expect(ticket.id, equals('test_id'));
      expect(ticket.name, equals('テスト券'));
      expect(ticket.description, equals('テスト用のご褒美券です'));
      expect(ticket.iconPath, equals('assets/icons/test.png'));
      expect(ticket.target, equals('parent'));
      expect(ticket.extra, isNull);
    });

    test('should create a reward ticket with extra fields', () {
      final extra = {'customField': 'customValue'};
      final ticket = RewardTicket(
        id: 'test_id',
        name: 'テスト券',
        description: 'テスト用のご褒美券です',
        iconPath: 'assets/icons/test.png',
        target: 'child',
        extra: extra,
      );

      expect(ticket.extra, equals(extra));
      expect(ticket.target, equals('child'));
    });

    test('should handle different target values', () {
      final parentTicket = RewardTicket(
        id: 'parent_id',
        name: '親用券',
        description: '親用の券です',
        iconPath: 'assets/icons/parent.png',
        target: 'parent',
      );

      final childTicket = RewardTicket(
        id: 'child_id',
        name: '子ども用券',
        description: '子ども用の券です',
        iconPath: 'assets/icons/child.png',
        target: 'child',
      );

      expect(parentTicket.target, equals('parent'));
      expect(childTicket.target, equals('child'));
    });
  });
}
