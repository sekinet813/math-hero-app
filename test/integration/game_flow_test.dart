import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/main.dart';
import 'package:math_hero_app/screens/game_play_screen.dart';
import 'package:math_hero_app/widgets/correct_answer_overlay.dart';

void main() {
  group('Game Flow Integration Tests', () {
    testWidgets('完全なゲームフローが動作する', (WidgetTester tester) async {
      await tester.pumpWidget(const MathHeroApp());
      await tester.pumpAndSettle();

      // ゲーム開始ボタンをタップ
      await tester.tap(find.text('ゲームを始める'));
      await tester.pumpAndSettle();

      // タイムアタックを選択
      await tester.tap(find.text('タイムアタック'));
      await tester.pumpAndSettle();

      // 足し算を選択
      await tester.tap(find.text('足し算'));
      await tester.pumpAndSettle();

      // かんたんを選択
      await tester.tap(find.text('かんたん'));
      await tester.pumpAndSettle();

      // ゲーム画面が表示されることを確認
      expect(find.byType(GamePlayScreen), findsOneWidget);

      // 選択肢をタップ
      final choiceButtons = find.byType(FilledButton);
      if (choiceButtons.evaluate().isNotEmpty) {
        await tester.tap(choiceButtons.first);
        await tester.pump();

        // オーバーレイが表示されることを確認
        expect(find.byType(CorrectAnswerOverlay), findsOneWidget);

        // タイマーが完了するまで待機
        await tester.pump(const Duration(milliseconds: 1600));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('エンドレスモードのフローが動作する', (WidgetTester tester) async {
      await tester.pumpWidget(const MathHeroApp());
      await tester.pumpAndSettle();

      // ゲーム開始ボタンをタップ
      await tester.tap(find.text('ゲームを始める'));
      await tester.pumpAndSettle();

      // エンドレスを選択
      await tester.tap(find.text('エンドレス'));
      await tester.pumpAndSettle();

      // 足し算を選択
      await tester.tap(find.text('足し算'));
      await tester.pumpAndSettle();

      // かんたんを選択
      await tester.tap(find.text('かんたん'));
      await tester.pumpAndSettle();

      // ゲーム画面が表示されることを確認
      expect(find.byType(GamePlayScreen), findsOneWidget);

      // 選択肢をタップ
      final choiceButtons = find.byType(FilledButton);
      if (choiceButtons.evaluate().isNotEmpty) {
        await tester.tap(choiceButtons.first);
        await tester.pump();

        // オーバーレイが表示されることを確認
        expect(find.byType(CorrectAnswerOverlay), findsOneWidget);

        // タイマーが完了するまで待機
        await tester.pump(const Duration(milliseconds: 2100));
        await tester.pumpAndSettle();
      }
    });
  });
}
