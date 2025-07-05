import 'package:flutter/material.dart';
import '../models/battle_match.dart';
import '../models/math_problem.dart';
import '../utils/math_problem_generator.dart';
import '../utils/sound_manager.dart';
import 'base_game_provider.dart';

/// 対戦状態を管理するProvider
class BattleProvider extends BaseGameProvider {
  // 対戦設定
  String _player1Name = '';
  String _player2Name = '';
  MathCategory _selectedCategory = MathCategory.addition;
  DifficultyLevel _selectedDifficulty = DifficultyLevel.easy;
  int _questionsPerPlayer = 5; // 1人あたりの問題数

  // 対戦状態
  BattleMatch? _currentMatch;
  int _currentPlayerIndex = 0; // 0: player1, 1: player2
  int _player1Score = 0;
  int _player2Score = 0;
  int _currentQuestionIndex = 0;
  bool _isBattleFinished = false;

  // 効果音管理
  final SoundManager _soundManager = SoundManager();

  // ゲッター
  String get player1Name => _player1Name;
  String get player2Name => _player2Name;
  MathCategory get selectedCategory => _selectedCategory;
  DifficultyLevel get selectedDifficulty => _selectedDifficulty;
  int get questionsPerPlayer => _questionsPerPlayer;
  BattleMatch? get currentMatch => _currentMatch;
  int get currentPlayerIndex => _currentPlayerIndex;
  int get player1Score => _player1Score;
  int get player2Score => _player2Score;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isBattleFinished => _isBattleFinished;

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
    setActive(true);
    _isBattleFinished = false;

    generateNewProblem(
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
    );

    // ゲーム開始音を再生
    _soundManager.playGameStartSound();

    notifyListeners();
  }

  /// 対戦を終了
  void endBattle() {
    setActive(false);
    _isBattleFinished = true;

    // ゲーム終了音を再生
    _soundManager.playGameEndSound();

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

  /// 回答を送信（オーバーライド）
  @override
  void submitAnswer(int answer) {
    if (!isActive || currentProblem == null || showCorrectAnswer) {
      return;
    }

    final isCorrect = answer == currentProblem!.correctAnswer;

    // スコアを更新
    if (isCorrect) {
      if (_currentPlayerIndex == 0) {
        _player1Score++;
      } else {
        _player2Score++;
      }
    }

    // 基本処理を呼び出し
    super.submitAnswer(answer);
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

    generateNewProblem(
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
    );
  }

  /// 勝者を判定
  String _getWinner() {
    if (_player1Score > _player2Score) {
      return _player1Name;
    } else if (_player2Score > _player1Score) {
      return _player2Name;
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

  /// フィードバック完了時の処理
  @override
  void onFeedbackComplete(bool isCorrect) {
    _nextQuestion();
  }

  @override
  void dispose() {
    _soundManager.dispose();
    super.dispose();
  }
}
