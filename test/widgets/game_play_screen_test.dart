import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:math_hero_app/screens/game_play_screen.dart';
import 'package:math_hero_app/providers/game_provider.dart';
import 'package:math_hero_app/utils/math_problem_generator.dart';
import 'package:math_hero_app/widgets/game_header.dart';
import 'package:math_hero_app/widgets/problem_display.dart';

void main() {
  group('GamePlayScreen', () {
    late GameProvider gameProvider;

    setUp(() {
      gameProvider = GameProvider();
    });

    tearDown(() {
      gameProvider.dispose();
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

        // 選択肢ボタンが表示されることを確認
        expect(find.byType(FilledButton), findsNWidgets(4));
      });

      testWidgets('ゲームヘッダーが表示される', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // ゲームヘッダーが表示されることを確認
        expect(find.byType(GameHeader), findsOneWidget);
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

    group('タイマー処理', () {
      testWidgets('タイマーが適切に処理される', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // 正解の選択肢をタップ
        final correctAnswer = gameProvider.currentProblem!.correctAnswer;
        final choiceButtons = find.byType(FilledButton);

        // 正解の選択肢を見つけてタップ
        for (int i = 0; i < choiceButtons.evaluate().length; i++) {
          final button = choiceButtons.at(i);
          final buttonText = tester
              .widget<FilledButton>(button)
              .child
              .toString();
          if (buttonText.contains(correctAnswer.toString())) {
            await tester.tap(button);
            break;
          }
        }

        // タイマーが完了するまで待機
        await tester.pump(const Duration(milliseconds: 1500));
        await tester.pumpAndSettle();

        // 問題数が増加することを確認
        expect(gameProvider.totalQuestions, 1);
      });
    });
  });
}
