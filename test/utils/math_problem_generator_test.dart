import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/utils/math_problem_generator.dart';

void main() {
  group('MathProblemGenerator', () {
    test('should generate addition problem', () {
      final problem = MathProblemGenerator.generateProblem(
        category: MathCategory.addition,
        difficulty: DifficultyLevel.easy,
      );

      expect(problem.category, 'addition');
      expect(problem.operator, '+');
      expect(problem.correctAnswer, problem.leftOperand + problem.rightOperand);
      expect(problem.difficulty, 'easy');
    });

    test('should generate subtraction problem', () {
      final problem = MathProblemGenerator.generateProblem(
        category: MathCategory.subtraction,
        difficulty: DifficultyLevel.medium,
      );

      expect(problem.category, 'subtraction');
      expect(problem.operator, '-');
      expect(problem.correctAnswer, problem.leftOperand - problem.rightOperand);
      expect(problem.difficulty, 'medium');
      expect(problem.leftOperand >= problem.rightOperand, true);
    });

    test('should generate multiplication problem', () {
      final problem = MathProblemGenerator.generateProblem(
        category: MathCategory.multiplication,
        difficulty: DifficultyLevel.hard,
      );

      expect(problem.category, 'multiplication');
      expect(problem.operator, '×');
      expect(problem.correctAnswer, problem.leftOperand * problem.rightOperand);
      expect(problem.difficulty, 'hard');
    });

    test('should generate division problem', () {
      final problem = MathProblemGenerator.generateProblem(
        category: MathCategory.division,
        difficulty: DifficultyLevel.easy,
      );

      expect(problem.category, 'division');
      expect(problem.operator, '÷');
      expect(
        problem.correctAnswer,
        problem.leftOperand ~/ problem.rightOperand,
      );
      expect(problem.difficulty, 'easy');
      expect(problem.leftOperand % problem.rightOperand, 0); // 割り切れる
    });

    test('should generate multiple problems', () {
      final problems = MathProblemGenerator.generateProblems(
        category: MathCategory.addition,
        difficulty: DifficultyLevel.easy,
        count: 5,
      );

      expect(problems.length, 5);
      for (final problem in problems) {
        expect(problem.category, 'addition');
        expect(problem.difficulty, 'easy');
      }
    });

    test('should generate random problems', () {
      final problem = MathProblemGenerator.generateRandomProblem(
        difficulty: DifficultyLevel.medium,
      );

      expect(problem.difficulty, 'medium');
      expect([
        'addition',
        'subtraction',
        'multiplication',
        'division',
      ], contains(problem.category));
    });

    test('should generate multiple random problems', () {
      final problems = MathProblemGenerator.generateRandomProblems(
        difficulty: DifficultyLevel.hard,
        count: 10,
      );

      expect(problems.length, 10);
      for (final problem in problems) {
        expect(problem.difficulty, 'hard');
      }
    });

    group('Difficulty levels', () {
      test('easy addition should not have carry over', () {
        for (int i = 0; i < 100; i++) {
          final problem = MathProblemGenerator.generateProblem(
            category: MathCategory.addition,
            difficulty: DifficultyLevel.easy,
          );
          expect(problem.leftOperand + problem.rightOperand, lessThan(10));
        }
      });

      test('easy subtraction should not have borrow', () {
        for (int i = 0; i < 100; i++) {
          final problem = MathProblemGenerator.generateProblem(
            category: MathCategory.subtraction,
            difficulty: DifficultyLevel.easy,
          );
          expect(
            problem.leftOperand,
            greaterThanOrEqualTo(problem.rightOperand),
          );
          expect(
            problem.leftOperand - problem.rightOperand,
            greaterThanOrEqualTo(0),
          );
        }
      });

      test('division should always be divisible', () {
        for (int i = 0; i < 100; i++) {
          final problem = MathProblemGenerator.generateProblem(
            category: MathCategory.division,
            difficulty: DifficultyLevel.easy,
          );
          expect(problem.leftOperand % problem.rightOperand, 0);
        }
      });
    });

    test('should generate valid operands within range', () {
      for (final category in MathCategory.values) {
        for (final difficulty in DifficultyLevel.values) {
          final problem = MathProblemGenerator.generateProblem(
            category: category,
            difficulty: difficulty,
          );

          expect(problem.leftOperand, greaterThan(0));
          expect(problem.rightOperand, greaterThan(0));
          expect(problem.correctAnswer, greaterThanOrEqualTo(0));
        }
      }
    });
  });
}
