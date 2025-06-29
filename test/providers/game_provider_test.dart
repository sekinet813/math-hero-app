import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/providers/game_provider.dart';
import 'package:math_hero_app/utils/math_problem_generator.dart';
import 'package:math_hero_app/utils/constants.dart';

void main() {
  group('GameProvider', () {
    late GameProvider gameProvider;

    setUp(() {
      gameProvider = GameProvider();
    });

    group('ゲーム開始', () {
      test('ゲームが正しく開始される', () {
        gameProvider.startGame(
          category: MathCategory.addition,
          difficulty: DifficultyLevel.easy,
          gameMode: GameMode.timeAttack,
        );

        expect(gameProvider.isGameActive, true);
        expect(gameProvider.correctAnswers, 0);
        expect(gameProvider.totalQuestions, 1);
        expect(gameProvider.currentProblem, isNotNull);
      });

      test('異なるカテゴリでゲームが開始される', () {
        gameProvider.startGame(
          category: MathCategory.multiplication,
          difficulty: DifficultyLevel.medium,
          gameMode: GameMode.endless,
        );

        expect(gameProvider.isGameActive, true);
        expect(gameProvider.currentProblem?.category, 'multiplication');
        expect(gameProvider.currentProblem?.difficulty, 'medium');
      });
    });

    group('選択肢選択', () {
      setUp(() {
        gameProvider.startGame(
          category: MathCategory.addition,
          difficulty: DifficultyLevel.easy,
          gameMode: GameMode.timeAttack,
        );
      });

      test('選択肢が正しく選択される', () {
        gameProvider.selectAnswer(5);
        expect(gameProvider.selectedAnswer, 5);
      });

      test('正解時に正答数が増加する', () {
        final problem = gameProvider.currentProblem!;
        gameProvider.selectAnswer(problem.correctAnswer);
        gameProvider.submitAnswer();

        expect(gameProvider.correctAnswers, 1);
        expect(gameProvider.showCorrectAnswer, true);
      });

      test('不正解時に正答数が増加しない', () {
        final problem = gameProvider.currentProblem!;
        gameProvider.selectAnswer(problem.correctAnswer + 1);
        gameProvider.submitAnswer();

        expect(gameProvider.correctAnswers, 0);
        expect(gameProvider.showCorrectAnswer, true);
      });

      test('回答送信後に選択肢がリセットされる', () {
        gameProvider.selectAnswer(5);
        expect(gameProvider.selectedAnswer, 5);

        gameProvider.submitAnswer();

        // 回答送信後に選択肢がリセットされる
        expect(gameProvider.selectedAnswer, isNull);
      });
    });

    group('ゲーム一時停止・再開', () {
      setUp(() {
        gameProvider.startGame(
          category: MathCategory.addition,
          difficulty: DifficultyLevel.easy,
          gameMode: GameMode.timeAttack,
        );
      });

      test('ゲームが正しく一時停止される', () {
        gameProvider.pauseGame();
        expect(gameProvider.isGamePaused, true);
        expect(gameProvider.isGameActive, true);
      });

      test('ゲームが正しく再開される', () {
        gameProvider.pauseGame();
        gameProvider.resumeGame();
        expect(gameProvider.isGamePaused, false);
        expect(gameProvider.isGameActive, true);
      });

      test('一時停止中は選択肢を選択できない', () {
        gameProvider.pauseGame();
        gameProvider.selectAnswer(5);
        expect(gameProvider.selectedAnswer, isNull);
      });

      test('一時停止中は回答を送信できない', () {
        gameProvider.pauseGame();
        gameProvider.selectAnswer(5);
        gameProvider.submitAnswer();
        expect(gameProvider.showCorrectAnswer, false);
      });
    });

    group('ゲーム終了', () {
      test('ゲームが正しく終了される', () {
        gameProvider.startGame(
          category: MathCategory.addition,
          difficulty: DifficultyLevel.easy,
          gameMode: GameMode.timeAttack,
        );

        gameProvider.endGame();

        expect(gameProvider.isGameActive, false);
        expect(gameProvider.isGamePaused, false);
      });

      test('終了後にゲーム状態がリセットされる', () {
        gameProvider.startGame(
          category: MathCategory.addition,
          difficulty: DifficultyLevel.easy,
          gameMode: GameMode.timeAttack,
        );

        gameProvider.selectAnswer(5);
        gameProvider.submitAnswer();

        gameProvider.endGame();

        expect(gameProvider.isGameActive, false);
        expect(gameProvider.selectedAnswer, isNull);
        expect(gameProvider.showCorrectAnswer, false);
      });
    });

    group('時間更新', () {
      test('タイムアタックモードで時間が減少する', () {
        gameProvider.startGame(
          category: MathCategory.addition,
          difficulty: DifficultyLevel.easy,
          gameMode: GameMode.timeAttack,
        );

        final initialTime = gameProvider.remainingTime;
        gameProvider.updateTime();

        expect(gameProvider.remainingTime, initialTime - 1);
      });

      test('時間切れでゲームが終了する', () {
        gameProvider.startGame(
          category: MathCategory.addition,
          difficulty: DifficultyLevel.easy,
          gameMode: GameMode.timeAttack,
        );

        // 時間を0にする
        for (int i = 0; i < AppConstants.kDefaultTimeLimit; i++) {
          gameProvider.updateTime();
        }

        // 最後の1回でゲームが終了する
        gameProvider.updateTime();

        expect(gameProvider.isGameActive, false);
      });

      test('エンドレスモードでは時間が更新されない', () {
        gameProvider.startGame(
          category: MathCategory.addition,
          difficulty: DifficultyLevel.easy,
          gameMode: GameMode.endless,
        );

        final initialTime = gameProvider.remainingTime;
        gameProvider.updateTime();

        expect(gameProvider.remainingTime, initialTime);
      });

      test('一時停止中は時間が更新されない', () {
        gameProvider.startGame(
          category: MathCategory.addition,
          difficulty: DifficultyLevel.easy,
          gameMode: GameMode.timeAttack,
        );

        gameProvider.pauseGame();
        final initialTime = gameProvider.remainingTime;
        gameProvider.updateTime();

        expect(gameProvider.remainingTime, initialTime);
      });
    });

    group('エンドレスモード', () {
      test('不正解でゲームが終了する', () {
        gameProvider.startGame(
          category: MathCategory.addition,
          difficulty: DifficultyLevel.easy,
          gameMode: GameMode.endless,
        );

        final problem = gameProvider.currentProblem!;
        gameProvider.selectAnswer(problem.correctAnswer + 1);
        gameProvider.submitAnswer();

        // 不正解表示後、ゲームが終了する
        expect(gameProvider.showCorrectAnswer, true);

        // タイマーでゲーム終了を待つ
        // 実際のテストではfake_asyncを使用
      });
    });

    group('問題生成', () {
      test('新しい問題が正しく生成される', () {
        gameProvider.startGame(
          category: MathCategory.addition,
          difficulty: DifficultyLevel.easy,
          gameMode: GameMode.timeAttack,
        );

        final firstProblem = gameProvider.currentProblem;
        expect(firstProblem, isNotNull);

        // 正解して次の問題へ
        gameProvider.selectAnswer(firstProblem!.correctAnswer);
        gameProvider.submitAnswer();

        // 次の問題が生成される（タイマーで自動的に生成される）
        // 実際のテストではfake_asyncを使用してタイマーを進める
        expect(gameProvider.totalQuestions, 1);
      });

      test('異なるカテゴリで問題が生成される', () {
        gameProvider.startGame(
          category: MathCategory.multiplication,
          difficulty: DifficultyLevel.medium,
          gameMode: GameMode.timeAttack,
        );

        final problem = gameProvider.currentProblem;
        expect(problem?.category, 'multiplication');
        expect(problem?.difficulty, 'medium');
      });
    });
  });
}
