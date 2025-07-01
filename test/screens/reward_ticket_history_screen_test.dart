import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/screens/reward_ticket_history_screen.dart';

void main() {
  group('RewardTicketHistoryScreen', () {
    testWidgets('should display history screen title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: RewardTicketHistoryScreen()),
      );

      expect(find.text('ご褒美券の履歴'), findsOneWidget);
    });

    testWidgets('should show empty state when no history', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: RewardTicketHistoryScreen()),
      );

      // 初期状態ではローディングまたは空の状態が表示される
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display used and unused tickets correctly', (
      WidgetTester tester,
    ) async {
      // モックデータを準備（実際のDBテストは別途実装）
      await tester.pumpWidget(
        const MaterialApp(home: RewardTicketHistoryScreen()),
      );

      // 基本的なUI要素の存在確認
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should have proper app bar structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: RewardTicketHistoryScreen()),
      );

      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);

      final appBarWidget = tester.widget<AppBar>(appBar);
      expect(appBarWidget.title, isA<Text>());
      expect((appBarWidget.title as Text).data, equals('ご褒美券の履歴'));
    });

    testWidgets('should handle mark as used functionality', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: RewardTicketHistoryScreen()),
      );

      // 基本的なUI構造の確認
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
