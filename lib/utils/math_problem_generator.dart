import 'dart:math';
import 'constants.dart';
import '../models/math_problem.dart';

/// 計算問題生成の難易度レベル
enum DifficultyLevel { easy, medium, hard }

/// 計算カテゴリ
enum MathCategory { addition, subtraction, multiplication, division }

/// 計算問題を生成するユーティリティクラス
class MathProblemGenerator {
  static final Random _random = Random();

  /// 指定されたカテゴリと難易度で計算問題を生成
  static MathProblem generateProblem({
    required MathCategory category,
    required DifficultyLevel difficulty,
  }) {
    switch (category) {
      case MathCategory.addition:
        return _generateAdditionProblem(difficulty);
      case MathCategory.subtraction:
        return _generateSubtractionProblem(difficulty);
      case MathCategory.multiplication:
        return _generateMultiplicationProblem(difficulty);
      case MathCategory.division:
        return _generateDivisionProblem(difficulty);
    }
  }

  /// 複数の問題を生成
  static List<MathProblem> generateProblems({
    required MathCategory category,
    required DifficultyLevel difficulty,
    required int count,
  }) {
    final problems = <MathProblem>[];
    for (int i = 0; i < count; i++) {
      problems.add(generateProblem(category: category, difficulty: difficulty));
    }
    return problems;
  }

  /// 足し算問題を生成
  static MathProblem _generateAdditionProblem(DifficultyLevel difficulty) {
    int leftOperand, rightOperand;

    switch (difficulty) {
      case DifficultyLevel.easy:
        // 1桁 + 1桁（繰り上がりなし）
        leftOperand = _random.nextInt(5) + 1; // 1-5
        rightOperand = _random.nextInt(9 - leftOperand) + 1; // 繰り上がりなし
        break;
      case DifficultyLevel.medium:
        // 1桁 + 1桁（繰り上がりあり）
        leftOperand = _random.nextInt(9) + 1; // 1-9
        rightOperand = _random.nextInt(9) + 1; // 1-9
        break;
      case DifficultyLevel.hard:
        // 2桁 + 1桁 または 1桁 + 2桁
        if (_random.nextBool()) {
          leftOperand = _random.nextInt(90) + 10; // 10-99
          rightOperand = _random.nextInt(9) + 1; // 1-9
        } else {
          leftOperand = _random.nextInt(9) + 1; // 1-9
          rightOperand = _random.nextInt(90) + 10; // 10-99
        }
        break;
    }

    return MathProblem(
      leftOperand: leftOperand,
      rightOperand: rightOperand,
      operator: '+',
      correctAnswer: leftOperand + rightOperand,
      category: 'addition',
      difficulty: difficulty.name,
    );
  }

  /// 引き算問題を生成
  static MathProblem _generateSubtractionProblem(DifficultyLevel difficulty) {
    int leftOperand, rightOperand;

    switch (difficulty) {
      case DifficultyLevel.easy:
        // 1桁 - 1桁（繰り下がりなし）
        leftOperand = _random.nextInt(9) + 1; // 1-9
        rightOperand = _random.nextInt(leftOperand) + 1; // 繰り下がりなし
        break;
      case DifficultyLevel.medium:
        // 1桁 - 1桁（繰り下がりあり）
        leftOperand = _random.nextInt(9) + 1; // 1-9
        rightOperand = _random.nextInt(9) + 1; // 1-9
        // 左辺が右辺より大きいことを保証
        if (leftOperand < rightOperand) {
          final temp = leftOperand;
          leftOperand = rightOperand;
          rightOperand = temp;
        }
        break;
      case DifficultyLevel.hard:
        // 2桁 - 1桁 または 2桁 - 2桁
        if (_random.nextBool()) {
          leftOperand = _random.nextInt(90) + 10; // 10-99
          rightOperand = _random.nextInt(9) + 1; // 1-9
        } else {
          leftOperand = _random.nextInt(90) + 10; // 10-99
          rightOperand = _random.nextInt(leftOperand - 9) + 10; // 10以上で左辺より小さい
        }
        break;
    }

    return MathProblem(
      leftOperand: leftOperand,
      rightOperand: rightOperand,
      operator: '-',
      correctAnswer: leftOperand - rightOperand,
      category: 'subtraction',
      difficulty: difficulty.name,
    );
  }

  /// 掛け算問題を生成
  static MathProblem _generateMultiplicationProblem(
    DifficultyLevel difficulty,
  ) {
    int leftOperand, rightOperand;

    switch (difficulty) {
      case DifficultyLevel.easy:
        // 1桁 × 1桁
        leftOperand = _random.nextInt(9) + 1; // 1-9
        rightOperand = _random.nextInt(9) + 1; // 1-9
        break;
      case DifficultyLevel.medium:
        // 1桁 × 2桁 または 2桁 × 1桁
        if (_random.nextBool()) {
          leftOperand = _random.nextInt(9) + 1; // 1-9
          rightOperand = _random.nextInt(20) + 10; // 10-29
        } else {
          leftOperand = _random.nextInt(20) + 10; // 10-29
          rightOperand = _random.nextInt(9) + 1; // 1-9
        }
        break;
      case DifficultyLevel.hard:
        // 2桁 × 2桁（ただし結果が1000未満）
        leftOperand = _random.nextInt(30) + 10; // 10-39
        rightOperand = _random.nextInt(25) + 10; // 10-34
        break;
    }

    return MathProblem(
      leftOperand: leftOperand,
      rightOperand: rightOperand,
      operator: '×',
      correctAnswer: leftOperand * rightOperand,
      category: 'multiplication',
      difficulty: difficulty.name,
    );
  }

  /// 割り算問題を生成
  static MathProblem _generateDivisionProblem(DifficultyLevel difficulty) {
    int leftOperand, rightOperand;

    switch (difficulty) {
      case DifficultyLevel.easy:
        // 割り切れる1桁 ÷ 1桁
        rightOperand = _random.nextInt(9) + 1; // 1-9
        final quotient = _random.nextInt(9) + 1; // 1-9
        leftOperand = rightOperand * quotient;
        break;
      case DifficultyLevel.medium:
        // 割り切れる2桁 ÷ 1桁
        rightOperand = _random.nextInt(9) + 1; // 1-9
        final quotient = _random.nextInt(20) + 10; // 10-29
        leftOperand = rightOperand * quotient;
        break;
      case DifficultyLevel.hard:
        // 割り切れる2桁 ÷ 2桁
        rightOperand = _random.nextInt(20) + 10; // 10-29
        final quotient = _random.nextInt(10) + 1; // 1-10
        leftOperand = rightOperand * quotient;
        break;
    }

    return MathProblem(
      leftOperand: leftOperand,
      rightOperand: rightOperand,
      operator: '÷',
      correctAnswer: leftOperand ~/ rightOperand,
      category: 'division',
      difficulty: difficulty.name,
    );
  }

  /// ランダムなカテゴリで問題を生成
  static MathProblem generateRandomProblem({
    required DifficultyLevel difficulty,
  }) {
    final categories = MathCategory.values;
    final randomCategory = categories[_random.nextInt(categories.length)];
    return generateProblem(category: randomCategory, difficulty: difficulty);
  }

  /// 複数のランダムな問題を生成
  static List<MathProblem> generateRandomProblems({
    required DifficultyLevel difficulty,
    required int count,
  }) {
    final problems = <MathProblem>[];
    for (int i = 0; i < count; i++) {
      problems.add(generateRandomProblem(difficulty: difficulty));
    }
    return problems;
  }
}
