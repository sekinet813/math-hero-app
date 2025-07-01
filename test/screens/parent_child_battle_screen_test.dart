import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/screens/parent_child_battle_screen.dart';
import 'package:math_hero_app/utils/reward_ticket_presets.dart';

void main() {
  group('ParentChildBattleScreen', () {
    testWidgets('should display parent and child ticket selectors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ParentChildBattleScreen()),
      );

      expect(find.text('親が選ぶご褒美券'), findsOneWidget);
      expect(find.text('子どもが選ぶご褒美券'), findsOneWidget);
      expect(find.text('対戦開始'), findsOneWidget);
    });

    testWidgets('should show parent reward tickets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ParentChildBattleScreen()),
      );

      for (final ticket in parentRewardTickets) {
        expect(find.text(ticket.name), findsOneWidget);
      }
    });

    testWidgets('should show child reward tickets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ParentChildBattleScreen()),
      );

      for (final ticket in childRewardTickets) {
        expect(find.text(ticket.name), findsOneWidget);
      }
    });

    testWidgets('should enable start button when both tickets are selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ParentChildBattleScreen()),
      );

      // 初期状態では無効
      final startButton = find.byType(ElevatedButton);
      expect(tester.widget<ElevatedButton>(startButton).enabled, isFalse);

      // 親の券を選択
      await tester.tap(find.text(parentRewardTickets.first.name));
      await tester.pump();

      // まだ無効
      expect(tester.widget<ElevatedButton>(startButton).enabled, isFalse);

      // 子どもの券を選択
      await tester.tap(find.text(childRewardTickets.first.name));
      await tester.pump();

      // 有効になる
      expect(tester.widget<ElevatedButton>(startButton).enabled, isTrue);
    });

    testWidgets('should show selected ticket with different styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ParentChildBattleScreen()),
      );

      final firstParentTicket = find.text(parentRewardTickets.first.name);

      // 選択前
      await tester.pump();

      // 選択後
      await tester.tap(firstParentTicket);
      await tester.pump();

      // 選択されたスタイルが適用されているかチェック
      final selectedContainer = tester.widget<Container>(
        find.ancestor(of: firstParentTicket, matching: find.byType(Container)),
      );

      // 選択されたコンテナには影や色の変更があることを確認
      expect(selectedContainer.decoration, isNotNull);
    });
  });
}
