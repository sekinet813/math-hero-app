import 'package:flutter/material.dart';
import '../models/battle_match.dart';
import '../models/math_problem.dart';
import '../utils/math_problem_generator.dart';
import 'dart:async';

/// 対戦状態を管理するProvider
class BattleProvider extends ChangeNotifier {
  // 対戦設定
  String _player1Name = '';
  String _player2Name = '';
  MathCategory _selectedCategory = MathCategory.addition;
  DifficultyLevel _selectedDifficulty = DifficultyLevel.easy;
  int _questionsPerPlayer = 5; // 1人あたりの問題数

  // 対戦状態
  BattleMatch? _currentMatch;
  MathProblem? _currentProblem;
  int _currentPlayerIndex = 0; // 0: player1, 1: player2
  int _player1Score = 0;
  int _player2Score = 0;
  int _currentQuestionIndex = 0;
  bool _isBattleActive = false;
  bool _isBattleFinished = false;
  int? _selectedAnswer;
  bool _showCorrectAnswer = false;

  // タイマー管理
  Timer? _feedbackTimer;

  // ゲッター
  String get player1Name => _player1Name;
  String get player2Name => _player2Name;
  MathCategory get selectedCategory => _selectedCategory;
  DifficultyLevel get selectedDifficulty => _selectedDifficulty;
  int get questionsPerPlayer => _questionsPerPlayer;
  BattleMatch? get currentMatch => _currentMatch;
  MathProblem? get currentProblem => _currentProblem;
  int get currentPlayerIndex => _currentPlayerIndex;
  int get player1Score => _player1Score;
  int get player2Score => _player2Score;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isBattleActive => _isBattleActive;
  bool get isBattleFinished => _isBattleFinished;
  int? get selectedAnswer => _selectedAnswer;
  bool get showCorrectAnswer => _showCorrectAnswer;

  /// プレイヤー名を設定
  void setPlayerNames(String player1Name, String player2Name) {
    _player1Name = player1Name.trim();
    _player2Name = player2Name.trim();
    notifyListeners();
  }

  /// 対戦設定を更新
  void updateBattleSettings({
    MathCategory? category,
    DifficultyLevel? difficulty,
    int? questionsPerPlayer,
  }) {
    if (category != null) _selectedCategory = category;
    if (difficulty != null) _selectedDifficulty = difficulty;
    if (questionsPerPlayer != null) _questionsPerPlayer = questionsPerPlayer;
    notifyListeners();
  }

  /// 対戦を開始
  void startBattle() {
    if (_player1Name.isEmpty || _player2Name.isEmpty) return;

    _currentPlayerIndex = 0;
    _player1Score = 0;
    _player2Score = 0;
    _currentQuestionIndex = 0;
    _isBattleActive = true;
    _isBattleFinished = false;
    _selectedAnswer = null;
    _showCorrectAnswer = false;

    _generateNewProblem();
    notifyListeners();
  }

  /// 対戦を終了
  void endBattle() {
    _isBattleActive = false;
    _isBattleFinished = true;
    _selectedAnswer = null;
    _showCorrectAnswer = false;
    _cancelFeedbackTimer();

    // 対戦結果を作成
    final winner = _getWinner();
    _currentMatch = BattleMatch(
      player1Name: _player1Name,
      player2Name: _player2Name,
      player1Score: _player1Score,
      player2Score: _player2Score,
      winner: winner,
      createdAt: DateTime.now(),
    );

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

  /// 選択肢を選択（4択用）
  void selectAnswer(int answer) {
    if (!_isBattleActive || _showCorrectAnswer) return;

    _selectedAnswer = answer;
    notifyListeners();
  }

  /// 回答を送信する（4択選択と同時に実行）
  void submitAnswer(int answer) {
    if (!_isBattleActive || _currentProblem == null || _showCorrectAnswer) {
      return;
    }

    _selectedAnswer = answer;
    final isCorrect = answer == _currentProblem!.correctAnswer;

    // スコアを更新
    if (isCorrect) {
      if (_currentPlayerIndex == 0) {
        _player1Score++;
      } else {
        _player2Score++;
      }
    }

    _showCorrectAnswer = true;

    // フィードバックタイマー
    _cancelFeedbackTimer();
    _feedbackTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_isBattleActive) {
        _showCorrectAnswer = false;
        _selectedAnswer = null;
        _nextQuestion();
        notifyListeners();
      }
    });

    notifyListeners();
  }

  /// 次の問題またはプレイヤーに進む
  void _nextQuestion() {
    _currentQuestionIndex++;

    // 現在のプレイヤーの問題が終了した場合
    if (_currentQuestionIndex >= _questionsPerPlayer) {
      _currentQuestionIndex = 0;
      _currentPlayerIndex++;

      // 両プレイヤーの問題が終了した場合
      if (_currentPlayerIndex >= 2) {
        endBattle();
        return;
      }
    }

    _generateNewProblem();
  }

  /// 勝者を判定
  String _getWinner() {
    if (_player1Score > _player2Score) {
      return _player1Name;
    } else if (_player2Score > _player1Score) {
      return _player1Name;
    } else {
      return '引き分け';
    }
  }

  /// 現在のプレイヤー名を取得
  String getCurrentPlayerName() {
    return _currentPlayerIndex == 0 ? _player1Name : _player2Name;
  }

  /// 現在のプレイヤーのスコアを取得
  int getCurrentPlayerScore() {
    return _currentPlayerIndex == 0 ? _player1Score : _player2Score;
  }

  /// フィードバックタイマーをキャンセル
  void _cancelFeedbackTimer() {
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
  }

  @override
  void dispose() {
    _cancelFeedbackTimer();
    super.dispose();
  }
}
