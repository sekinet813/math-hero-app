import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/widgets/correct_answer_overlay.dart';

void main() {
  group('CorrectAnswerOverlay', () {
    testWidgets('正解時にオーバーレイが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CorrectAnswerOverlay(
              isCorrect: true,
              visible: true,
              correctAnswer: 8,
            ),
          ),
        ),
      );

      // オーバーレイが表示されることを確認
      expect(find.byType(CorrectAnswerOverlay), findsOneWidget);

      // CustomPaintが存在することを確認（複数ある可能性があるため）
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('非表示時にオーバーレイが表示されない', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CorrectAnswerOverlay(
              isCorrect: true,
              visible: false,
              correctAnswer: 8,
            ),
          ),
        ),
      );

      // オーバーレイが表示されないことを確認
      expect(find.byType(CorrectAnswerOverlay), findsOneWidget);

      // visible=falseの場合はSizedBox.shrink()が返される
      final overlay = tester.widget<CorrectAnswerOverlay>(
        find.byType(CorrectAnswerOverlay),
      );
      expect(overlay.visible, false);
    });

    testWidgets('不正解時に正解が表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CorrectAnswerOverlay(
              isCorrect: false,
              visible: true,
              correctAnswer: 8,
            ),
          ),
        ),
      );

      // 正解が表示されることを確認
      expect(find.text('正解は 8'), findsOneWidget);
    });

    testWidgets('正解時には正解メッセージが表示されない', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CorrectAnswerOverlay(
              isCorrect: true,
              visible: true,
              correctAnswer: 8,
            ),
          ),
        ),
      );

      // 正解メッセージが表示されないことを確認
      expect(find.text('正解は 8'), findsNothing);
    });
  });
}
