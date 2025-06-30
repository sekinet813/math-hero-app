/// 計算問題を管理するモデルクラス
class MathProblem {
  final int leftOperand;
  final int rightOperand;
  final String operator;
  final int correctAnswer;
  final String category;
  final String difficulty;

  const MathProblem({
    required this.leftOperand,
    required this.rightOperand,
    required this.operator,
    required this.correctAnswer,
    required this.category,
    required this.difficulty,
  });

  /// 問題文を生成
  String get questionText => '$leftOperand $operator $rightOperand = ?';

  /// 選択肢を生成（正解を含む4つの選択肢）
  List<int> generateChoices() {
    final choices = <int>[correctAnswer];

    // 正解に近い値を生成
    final variations = [
      correctAnswer + 1,
      correctAnswer - 1,
      correctAnswer + 2,
      correctAnswer - 2,
      correctAnswer + 5,
      correctAnswer - 5,
      correctAnswer + 10,
      correctAnswer - 10,
    ];

    // 重複を避けて選択肢を追加
    for (final variation in variations) {
      if (choices.length >= 4) break;
      if (variation >= 0 && !choices.contains(variation)) {
        choices.add(variation);
      }
    }

    // 4つに満たない場合はランダムな値を追加
    while (choices.length < 4) {
      final randomChoice = correctAnswer + (choices.length * 3);
      if (!choices.contains(randomChoice) && randomChoice >= 0) {
        choices.add(randomChoice);
      } else {
        // 負の値にならないように調整
        final fallbackChoice = correctAnswer + choices.length;
        if (!choices.contains(fallbackChoice)) {
          choices.add(fallbackChoice);
        }
      }
    }

    // 確実に4つの選択肢があることを保証
    if (choices.length < 4) {
      for (int i = choices.length; i < 4; i++) {
        choices.add(correctAnswer + i + 1);
      }
    }

    // シャッフルして返す
    choices.shuffle();
    return choices;
  }

  /// MapからMathProblemオブジェクトを作成
  factory MathProblem.fromMap(Map<String, dynamic> map) {
    return MathProblem(
      leftOperand: map['left_operand'] as int,
      rightOperand: map['right_operand'] as int,
      operator: map['operator'] as String,
      correctAnswer: map['correct_answer'] as int,
      category: map['category'] as String,
      difficulty: map['difficulty'] as String,
    );
  }

  /// MathProblemオブジェクトをMapに変換
  Map<String, dynamic> toMap() {
    return {
      'left_operand': leftOperand,
      'right_operand': rightOperand,
      'operator': operator,
      'correct_answer': correctAnswer,
      'category': category,
      'difficulty': difficulty,
    };
  }

  @override
  String toString() {
    return 'MathProblem($leftOperand $operator $rightOperand = $correctAnswer, category: $category, difficulty: $difficulty)';
  }
}
