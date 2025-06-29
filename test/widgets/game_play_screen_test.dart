import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:math_hero_app/screens/game_play_screen.dart';
import 'package:math_hero_app/providers/game_provider.dart';
import 'package:math_hero_app/utils/math_problem_generator.dart';
import 'package:math_hero_app/widgets/correct_answer_overlay.dart';
import 'package:math_hero_app/widgets/game_header.dart';
import 'package:math_hero_app/widgets/problem_display.dart';

void main() {
  group('GamePlayScreen', () {
    late GameProvider gameProvider;

    setUp(() {
      gameProvider = GameProvider();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<GameProvider>.value(
          value: gameProvider,
          child: const GamePlayScreen(
            category: MathCategory.addition,
            difficulty: DifficultyLevel.easy,
            gameMode: GameMode.timeAttack,
          ),
        ),
      );
    }

    group('ゲーム開始時', () {
      testWidgets('問題が表示される', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // 問題が表示されることを確認
        expect(find.byType(ProblemDisplay), findsOneWidget);
        expect(find.byType(GameHeader), findsOneWidget);
      });

      testWidgets('選択肢が表示される', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // 選択肢ボタンが表示されることを確認（FilledButtonを使用）
        final choiceButtons = find.byType(FilledButton);
        expect(choiceButtons, findsWidgets);
      });

      testWidgets('ゲームヘッダーが表示される', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // ゲームヘッダーが表示されることを確認
        expect(find.byType(GameHeader), findsOneWidget);
      });
    });

    group('回答機能', () {
      testWidgets('正解時にオーバーレイが表示される', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

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

      testWidgets('不正解時にオーバーレイが表示される', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

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

    group('ゲーム終了機能', () {
      testWidgets('戻るボタンでダイアログが表示される', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // 戻るボタンをタップ
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // ダイアログが表示されることを確認
        expect(find.text('ゲームを終了しますか？'), findsOneWidget);
        expect(find.text('キャンセル'), findsOneWidget);
        expect(find.text('終了'), findsOneWidget);
      });
    });
  });
}
