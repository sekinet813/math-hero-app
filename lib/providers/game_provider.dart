import 'package:flutter/material.dart';
import '../models/math_problem.dart';
import '../utils/math_problem_generator.dart';
import '../utils/constants.dart';
import 'dart:async';

/// ゲームモード
enum GameMode { timeAttack, endless }

/// ゲーム状態を管理するProvider
class GameProvider extends ChangeNotifier {
  // ゲーム設定
  MathCategory _selectedCategory = MathCategory.addition;
  DifficultyLevel _selectedDifficulty = DifficultyLevel.easy;
  GameMode _gameMode = GameMode.timeAttack;

  // ゲーム状態
  MathProblem? _currentProblem;
  int _correctAnswers = 0;
  int _totalQuestions = 0;
  int _remainingTime = AppConstants.kDefaultTimeLimit;
  bool _isGameActive = false;
  bool _isGamePaused = false;
  int? _selectedAnswer;
  bool _showCorrectAnswer = false;

  // タイマー管理
  Timer? _answerTimer;
  Timer? _feedbackTimer;

  // ゲッター
  MathCategory get selectedCategory => _selectedCategory;
  DifficultyLevel get selectedDifficulty => _selectedDifficulty;
  GameMode get gameMode => _gameMode;
  MathProblem? get currentProblem => _currentProblem;
  int get correctAnswers => _correctAnswers;
  int get totalQuestions => _totalQuestions;
  int get remainingTime => _remainingTime;
  bool get isGameActive => _isGameActive;
  bool get isGamePaused => _isGamePaused;
  int? get selectedAnswer => _selectedAnswer;
  bool get showCorrectAnswer => _showCorrectAnswer;

  /// ゲームを開始
  void startGame({
    required MathCategory category,
    required DifficultyLevel difficulty,
    required GameMode gameMode,
    int? timeLimit,
  }) {
    _selectedCategory = category;
    _selectedDifficulty = difficulty;
    _gameMode = gameMode;
    _correctAnswers = 0;
    _totalQuestions = 0;
    _remainingTime = timeLimit ?? AppConstants.kDefaultTimeLimit;
    _isGameActive = true;
    _isGamePaused = false;
    _selectedAnswer = null;
    _showCorrectAnswer = false;

    _generateNewProblem();
    notifyListeners();
  }

  /// ゲームを一時停止
  void pauseGame() {
    _isGamePaused = true;
    notifyListeners();
  }

  /// ゲームを再開
  void resumeGame() {
    _isGamePaused = false;
    notifyListeners();
  }

  /// ゲームを終了
  void endGame() {
    _isGameActive = false;
    _isGamePaused = false;
    _selectedAnswer = null;
    _showCorrectAnswer = false;
    _cancelAllTimers();
    notifyListeners();
  }

  /// 新しい問題を生成
  void _generateNewProblem() {
    try {
      _currentProblem = MathProblemGenerator.generateProblem(
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
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

  /// 次の問題を生成
  void _generateNextProblem() {
    _generateNewProblem();
  }

  /// 選択肢を選択
  void selectAnswer(int answer) {
    if (!_isGameActive || _isGamePaused || _showCorrectAnswer) return;

    _selectedAnswer = answer;
    notifyListeners();
  }

  /// 回答を送信する
  void submitAnswer(int answer) {
    if (!_isGameActive || _currentProblem == null || _isGamePaused) return;

    _selectedAnswer = answer;
    _totalQuestions++; // 問題数を増加
    final isCorrect = answer == _currentProblem!.correctAnswer;

    if (isCorrect) {
      _correctAnswers++;
      _showCorrectAnswer = true;

      // 正解時のタイマー
      _cancelFeedbackTimer();
      _feedbackTimer = Timer(const Duration(milliseconds: 800), () {
        if (_isGameActive) {
          _showCorrectAnswer = false;
          _selectedAnswer = null;
          _generateNextProblem();
          notifyListeners();
        }
      });
    } else {
      _showCorrectAnswer = true;

      // 不正解時のタイマー
      _cancelFeedbackTimer();
      _feedbackTimer = Timer(const Duration(milliseconds: 1500), () {
        if (_isGameActive) {
          _showCorrectAnswer = false;
          _selectedAnswer = null;

          if (_gameMode == GameMode.endless) {
            endGame();
          } else {
            _generateNextProblem();
          }
          notifyListeners();
        }
      });
    }

    notifyListeners();
  }

  /// 時間を更新（タイムアタックモード用）
  void updateTime() {
    if (!_isGameActive || _isGamePaused || _gameMode != GameMode.timeAttack) {
      return;
    }

    if (_remainingTime > 0) {
      _remainingTime--;

      // 時間が0になったらゲーム終了
      if (_remainingTime == 0) {
        endGame();
      }
    }

    notifyListeners();
  }

  /// フィードバックタイマーをキャンセル
  void _cancelFeedbackTimer() {
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
  }

  /// すべてのタイマーをキャンセル
  void _cancelAllTimers() {
    _answerTimer?.cancel();
    _answerTimer = null;
    _cancelFeedbackTimer();
  }

  @override
  void dispose() {
    _cancelAllTimers();
    super.dispose();
  }
}
