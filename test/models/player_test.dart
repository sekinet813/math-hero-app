import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/models/player.dart';

void main() {
  group('Player Model Tests', () {
    test('fromMapでPlayerオブジェクトが正しく作成される', () {
      final map = {
        'id': 1,
        'name': 'テストプレイヤー',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final player = Player.fromMap(map);

      expect(player.id, 1);
      expect(player.name, 'テストプレイヤー');
      expect(player.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
      expect(player.updatedAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
    });

    test('toMapでMapが正しく作成される', () {
      final player = Player(
        id: 1,
        name: 'テストプレイヤー',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      final map = player.toMap();

      expect(map['id'], 1);
      expect(map['name'], 'テストプレイヤー');
      expect(map['created_at'], '2024-01-01T00:00:00.000Z');
      expect(map['updated_at'], '2024-01-01T00:00:00.000Z');
    });

    test('copyWithで新しいPlayerオブジェクトが作成される', () {
      final originalPlayer = Player(
        id: 1,
        name: '元のプレイヤー',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      final newPlayer = originalPlayer.copyWith(
        name: '新しいプレイヤー',
        updatedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
      );

      expect(newPlayer.id, 1);
      expect(newPlayer.name, '新しいプレイヤー');
      expect(newPlayer.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
      expect(newPlayer.updatedAt, DateTime.parse('2024-01-02T00:00:00.000Z'));
    });
  });
}
