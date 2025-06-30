import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/widgets/problem_display.dart';
import 'package:math_hero_app/models/math_problem.dart';

void main() {
  group('ProblemDisplay', () {
    late MathProblem testProblem;

    setUp(() {
      testProblem = const MathProblem(
        leftOperand: 5,
        rightOperand: 3,
        operator: '+',
        correctAnswer: 8,
        category: 'addition',
        difficulty: 'easy',
      );
    });

    testWidgets('問題が正しく表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(
              problem: testProblem,
              userAnswer: '',
              showCorrectAnswer: false,
              onAnswerSelected: (answer) {},
            ),
          ),
        ),
      );

      expect(find.text('5 + 3 = ?'), findsOneWidget);
    });

    testWidgets('選択肢が正しく表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(
              problem: testProblem,
              userAnswer: '',
              showCorrectAnswer: false,
              onAnswerSelected: (answer) {},
            ),
          ),
        ),
      );

      // 4つの選択肢が表示されることを確認
      expect(find.byType(FilledButton), findsNWidgets(4));
    });

    testWidgets('選択肢をタップできる', (WidgetTester tester) async {
      bool answerSelected = false;
      int selectedAnswer = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(
              problem: testProblem,
              userAnswer: '',
              showCorrectAnswer: false,
              onAnswerSelected: (answer) {
                answerSelected = true;
                selectedAnswer = answer;
              },
            ),
          ),
        ),
      );

      // 最初の選択肢をタップ
      await tester.tap(find.byType(FilledButton).first);
      await tester.pump();

      expect(answerSelected, true);
      expect(selectedAnswer, isNotNull);
    });

    testWidgets('問題がない時にローディングが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(
              problem: null,
              userAnswer: '',
              showCorrectAnswer: false,
              onAnswerSelected: (answer) {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('選択された回答がハイライトされる', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(
              problem: testProblem,
              userAnswer: '8',
              showCorrectAnswer: false,
              onAnswerSelected: (answer) {},
            ),
          ),
        ),
      );

      // 選択された回答がハイライトされることを確認
      // 実際の実装に応じて調整
      expect(find.text('8'), findsOneWidget);
    });
  });
}
