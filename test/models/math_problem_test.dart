import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/models/math_problem.dart';

void main() {
  group('MathProblem', () {
    test('should create a valid math problem', () {
      const problem = MathProblem(
        leftOperand: 5,
        rightOperand: 3,
        operator: '+',
        correctAnswer: 8,
        category: 'addition',
        difficulty: 'easy',
      );

      expect(problem.leftOperand, 5);
      expect(problem.rightOperand, 3);
      expect(problem.operator, '+');
      expect(problem.correctAnswer, 8);
      expect(problem.category, 'addition');
      expect(problem.difficulty, 'easy');
    });

    test('should generate correct question text', () {
      const problem = MathProblem(
        leftOperand: 7,
        rightOperand: 4,
        operator: '-',
        correctAnswer: 3,
        category: 'subtraction',
        difficulty: 'medium',
      );

      expect(problem.questionText, '7 - 4 = ?');
    });

    test('should generate 4 choices including correct answer', () {
      const problem = MathProblem(
        leftOperand: 6,
        rightOperand: 2,
        operator: '×',
        correctAnswer: 12,
        category: 'multiplication',
        difficulty: 'easy',
      );

      final choices = problem.generateChoices();

      expect(choices.length, 4);
      expect(choices.contains(12), true); // 正解を含む
      expect(choices.toSet().length, 4); // 重複なし
    });

    test('should convert to and from map correctly', () {
      const problem = MathProblem(
        leftOperand: 10,
        rightOperand: 5,
        operator: '÷',
        correctAnswer: 2,
        category: 'division',
        difficulty: 'hard',
      );

      final map = problem.toMap();
      final restoredProblem = MathProblem.fromMap(map);

      expect(restoredProblem.leftOperand, problem.leftOperand);
      expect(restoredProblem.rightOperand, problem.rightOperand);
      expect(restoredProblem.operator, problem.operator);
      expect(restoredProblem.correctAnswer, problem.correctAnswer);
      expect(restoredProblem.category, problem.category);
      expect(restoredProblem.difficulty, problem.difficulty);
    });

    test('should generate valid choices for zero answer', () {
      const problem = MathProblem(
        leftOperand: 0,
        rightOperand: 5,
        operator: '×',
        correctAnswer: 0,
        category: 'multiplication',
        difficulty: 'easy',
      );

      final choices = problem.generateChoices();

      expect(choices.length, 4);
      expect(choices.contains(0), true);
      expect(choices.every((choice) => choice >= 0), true);
    });
  });
}
