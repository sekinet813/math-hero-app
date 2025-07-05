import 'package:flutter/material.dart';
import '../models/math_problem.dart';
import '../utils/constants.dart';
import '../utils/math_problem_generator.dart';
import '../utils/sound_manager.dart';
import 'base_game_provider.dart';
import 'dart:async';

/// ゲームモード
enum GameMode { timeAttack, challenge }

/// ゲーム状態を管理するProvider
class GameProvider extends BaseGameProvider {
  // ゲーム設定
  MathCategory _selectedCategory = MathCategory.addition;
  DifficultyLevel _selectedDifficulty = DifficultyLevel.easy;
  GameMode _gameMode = GameMode.timeAttack;

  // ゲーム状態
  int _correctAnswers = 0;
  int _totalQuestions = 0;
  int _remainingTime = AppConstants.kDefaultTimeLimit;
  bool _isGamePaused = false;

  // タイマー管理
  Timer? _answerTimer;

  // 効果音管理
  final SoundManager _soundManager = SoundManager();

  // ゲッター
  MathCategory get selectedCategory => _selectedCategory;
  DifficultyLevel get selectedDifficulty => _selectedDifficulty;
  GameMode get gameMode => _gameMode;
  int get correctAnswers => _correctAnswers;
  int get totalQuestions => _totalQuestions;
  int get remainingTime => _remainingTime;
  bool get isGamePaused => _isGamePaused;
  bool get isGameActive => isActive;

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
    setActive(true);
    _isGamePaused = false;

    generateNewProblem(
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
    );

    // ゲーム開始音を再生
    _soundManager.playGameStartSound();

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
    setActive(false);
    _isGamePaused = false;

    // ゲーム終了音を再生
    _soundManager.playGameEndSound();

    _cancelAllTimers();
    notifyListeners();
  }

  /// 次の問題を生成
  void _generateNextProblem() {
    generateNewProblem(
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
    );
  }

  /// 回答を送信（オーバーライド）
  @override
  void submitAnswer(int answer) {
    if (!isActive || currentProblem == null || _isGamePaused) return;

    _totalQuestions++; // 問題数を増加
    final isCorrect = answer == currentProblem!.correctAnswer;

    if (isCorrect) {
      _correctAnswers++;
    }

    // 基本処理を呼び出し
    super.submitAnswer(answer);
  }

  /// 時間を更新（タイムアタックモード用）
  void updateTime() {
    if (!isActive || _isGamePaused || _gameMode != GameMode.timeAttack) {
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

  /// フィードバック完了時の処理
  @override
  void onFeedbackComplete(bool isCorrect) {
    if (isCorrect) {
      // 正解時は次の問題へ
      _generateNextProblem();
    } else {
      // 不正解時
      if (_gameMode == GameMode.challenge) {
        endGame();
      } else {
        _generateNextProblem();
      }
    }
  }

  /// すべてのタイマーをキャンセル
  void _cancelAllTimers() {
    _answerTimer?.cancel();
    _answerTimer = null;
  }

  @override
  void dispose() {
    _cancelAllTimers();
    _soundManager.dispose();
    super.dispose();
  }
}
