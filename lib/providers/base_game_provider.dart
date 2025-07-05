import 'package:flutter/material.dart';
import '../models/math_problem.dart';
import '../utils/math_problem_generator.dart';
import '../utils/sound_manager.dart';
import 'dart:async';

/// ゲームプロバイダーのベースクラス
abstract class BaseGameProvider extends ChangeNotifier {
  // 共通の状態
  MathProblem? _currentProblem;
  int? _selectedAnswer;
  bool _showCorrectAnswer = false;
  bool _isActive = false;

  // タイマー管理
  Timer? _feedbackTimer;

  // 効果音管理
  final SoundManager _soundManager = SoundManager();

  // ゲッター
  MathProblem? get currentProblem => _currentProblem;
  int? get selectedAnswer => _selectedAnswer;
  bool get showCorrectAnswer => _showCorrectAnswer;
  bool get isActive => _isActive;

  /// アクティブ状態を設定
  void setActive(bool active) {
    _isActive = active;
  }

  /// 新しい問題を生成
  void generateNewProblem({
    required MathCategory category,
    required DifficultyLevel difficulty,
  }) {
    try {
      _currentProblem = MathProblemGenerator.generateProblem(
        category: category,
        difficulty: difficulty,
      );

      // 問題が生成されなかった場合のフォールバック
      _currentProblem ??= MathProblem(
        leftOperand: 1,
        rightOperand: 1,
        operator: '+',
        correctAnswer: 2,
        category: 'addition',
        difficulty: 'easy',
      );

      _selectedAnswer = null;
      _showCorrectAnswer = false;
    } catch (e) {
      // エラーが発生した場合はデフォルトの問題を生成
      _currentProblem = MathProblem(
        leftOperand: 1,
        rightOperand: 1,
        operator: '+',
        correctAnswer: 2,
        category: 'addition',
        difficulty: 'easy',
      );
      _selectedAnswer = null;
      _showCorrectAnswer = false;
    }
  }

  /// 選択肢を選択
  void selectAnswer(int answer) {
    if (!_isActive || _showCorrectAnswer) return;

    _selectedAnswer = answer;
    notifyListeners();
  }

  /// 回答を送信（基本処理）
  void submitAnswer(int answer) {
    if (!_isActive || _currentProblem == null || _showCorrectAnswer) {
      return;
    }

    _selectedAnswer = answer;
    final isCorrect = answer == _currentProblem!.correctAnswer;

    // 効果音を再生
    if (isCorrect) {
      _soundManager.playCorrectSound();
    } else {
      _soundManager.playIncorrectSound();
    }

    _showCorrectAnswer = true;

    // フィードバックタイマー
    _cancelFeedbackTimer();
    _feedbackTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_isActive) {
        _showCorrectAnswer = false;
        _selectedAnswer = null;
        onFeedbackComplete(isCorrect);
        notifyListeners();
      }
    });

    notifyListeners();
  }

  /// フィードバック完了時の処理（サブクラスで実装）
  void onFeedbackComplete(bool isCorrect);

  /// フィードバックタイマーをキャンセル
  void _cancelFeedbackTimer() {
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
  }

  /// リソースを解放
  void disposeResources() {
    _cancelFeedbackTimer();
    _soundManager.dispose();
  }

  @override
  void dispose() {
    disposeResources();
    super.dispose();
  }
}
