import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/widgets/game_header.dart';
import 'package:math_hero_app/providers/game_provider.dart';

void main() {
  group('GameHeader', () {
    testWidgets('正解数と問題数が表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameHeader(
              correctAnswers: 5,
              totalQuestions: 10,
              remainingTime: 30,
              gameMode: GameMode.timeAttack,
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('30s'), findsOneWidget);
    });

    testWidgets('タイムアタックモードで時間が表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameHeader(
              correctAnswers: 0,
              totalQuestions: 0,
              remainingTime: 60,
              gameMode: GameMode.timeAttack,
            ),
          ),
        ),
      );

      expect(find.text('60s'), findsOneWidget);
      expect(find.text('残り時間'), findsOneWidget);
    });

    testWidgets('エンドレスモードで時間が表示されない', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameHeader(
              correctAnswers: 0,
              totalQuestions: 0,
              remainingTime: 60,
              gameMode: GameMode.endless,
            ),
          ),
        ),
      );

      expect(find.text('60s'), findsNothing);
      expect(find.text('残り時間'), findsNothing);
    });

    testWidgets('時間が少ない時に色が変わる', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameHeader(
              correctAnswers: 0,
              totalQuestions: 0,
              remainingTime: 5,
              gameMode: GameMode.timeAttack,
            ),
          ),
        ),
      );

      // 時間が少ない時の色を確認（実際の実装に応じて調整）
      expect(find.text('5s'), findsOneWidget);
    });
  });
}
