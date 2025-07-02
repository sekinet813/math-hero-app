import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import '../utils/math_problem_generator.dart';
import '../models/reward_ticket.dart';
import '../utils/reward_ticket_db_helper.dart';
import '../models/reward_ticket_history.dart';
import 'common_game_screen.dart';

/// ゲームプレイ画面
class GamePlayScreen extends StatefulWidget {
  final MathCategory category;
  final DifficultyLevel difficulty;
  final GameMode gameMode;
  // 親子対戦時のご褒美券（nullなら通常モード）
  final RewardTicket? parentTicket;
  final RewardTicket? childTicket;
  final int? timeLimit;

  const GamePlayScreen({
    super.key,
    required this.category,
    required this.difficulty,
    required this.gameMode,
    this.parentTicket,
    this.childTicket,
    this.timeLimit,
  });

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  Timer? _timer;
  // final AudioPlayer _audioPlayer = AudioPlayer();
  bool _showEffect = false;
  bool _historySaved = false;
  String _userAnswer = '';
  int _countdown = 3;
  bool _isCountingDown = false;

  @override
  void initState() {
    super.initState();

    // タイムアタック時はカウントダウン演出
    if (widget.gameMode == GameMode.timeAttack) {
      setState(() {
        _isCountingDown = true;
        _countdown = 3;
      });
      _startCountdown();
    } else {
      // 通常モードは即開始
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final gameProvider = context.read<GameProvider>();
        if (!gameProvider.isGameActive) {
          gameProvider.startGame(
            category: widget.category,
            difficulty: widget.difficulty,
            gameMode: widget.gameMode,
            timeLimit: widget.timeLimit,
          );
        }
      });
    }
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else if (_countdown == 1) {
          _countdown = 0;
        } else {
          _isCountingDown = false;
          timer.cancel();
          // ゲーム開始
          final gameProvider = context.read<GameProvider>();
          if (!gameProvider.isGameActive) {
            gameProvider.startGame(
              category: widget.category,
              difficulty: widget.difficulty,
              gameMode: widget.gameMode,
              timeLimit: widget.timeLimit,
            );
            _startTimer();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // _audioPlayer.dispose();
    super.dispose();
  }

  /// タイマーを開始
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        context.read<GameProvider>().updateTime();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title;
    switch (widget.gameMode) {
      case GameMode.timeAttack:
        title = 'タイムアタック';
        break;
      case GameMode.endless:
        title = 'エンドレス';
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitDialog(context),
        ),
      ),
      body: _isCountingDown
          ? _buildCountdownUI()
          : Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                if (!gameProvider.isGameActive) {
                  _timer?.cancel();
                  return _buildGameEndScreen(gameProvider);
                }
                if (!gameProvider.showCorrectAnswer && _userAnswer.isNotEmpty) {
                  // 新しい問題 or 正解表示終了時にリセット
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _userAnswer = '';
                    });
                  });
                }
                return CommonGameScreen(
                  currentProblem: gameProvider.currentProblem,
                  userAnswer: gameProvider.selectedAnswer?.toString() ?? '',
                  showCorrectAnswer: gameProvider.showCorrectAnswer,
                  onAnswerSelected: (answer) {
                    gameProvider.selectAnswer(answer);
                    gameProvider.submitAnswer(answer);
                  },
                  correctAnswers: gameProvider.correctAnswers,
                  totalQuestions: gameProvider.totalQuestions,
                  remainingTime: gameProvider.remainingTime,
                  gameMode: gameProvider.gameMode,
                  showOverlay: gameProvider.showCorrectAnswer,
                  isCorrect:
                      gameProvider.selectedAnswer ==
                      gameProvider.currentProblem?.correctAnswer,
                  correctAnswer: gameProvider.currentProblem?.correctAnswer,
                );
              },
            ),
    );
  }

  /// カウントダウンUI
  Widget _buildCountdownUI() {
    String text;
    if (_countdown > 0) {
      text = _countdown.toString();
    } else {
      text = 'スタート!';
    }
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// ゲーム終了画面を構築
  Widget _buildGameEndScreen(GameProvider gameProvider) {
    final isParentChild =
        widget.parentTicket != null && widget.childTicket != null;
    final bool parentWin = (gameProvider.correctAnswers % 2 == 0); // 仮ロジック
    final RewardTicket? winnerTicket = isParentChild
        ? (parentWin ? widget.parentTicket : widget.childTicket)
        : null;
    final String winnerName = isParentChild
        ? (parentWin ? 'parent' : 'child')
        : '';

    // 履歴保存（初回のみ）
    if (isParentChild && winnerTicket != null && !_historySaved) {
      _saveHistory(winnerName, winnerTicket);
      _historySaved = true;
    }

    // タイムアタック用リザルト
    if (widget.gameMode == GameMode.timeAttack) {
      final int correct = gameProvider.correctAnswers;
      final int total = gameProvider.totalQuestions;
      final int time = widget.timeLimit ?? AppConstants.kDefaultTimeLimit;
      final double accuracy = total > 0 ? (correct / total * 100) : 0.0;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.kSpacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppConstants.kSpacing24),
              Text(
                'タイムアタック終了!',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing16),
              Text(
                '制限時間: $time秒',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing8),
              Text(
                '正解数: $correct問',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing8),
              Text(
                '総問題数: $total問',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing8),
              Text(
                '正答率: ${accuracy.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing24),
              FilledButton(
                onPressed: () {
                  // 再挑戦: 設定画面に戻る
                  Navigator.of(context).pop();
                },
                child: const Text('もう一度挑戦'),
              ),
              const SizedBox(height: AppConstants.kSpacing8),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ホームに戻る'),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.kSpacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppConstants.kSpacing24),
            Text(
              'ゲーム終了！',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            Text(
              '正解数: ${gameProvider.correctAnswers}問',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.kSpacing8),
            Text(
              '総問題数: ${gameProvider.totalQuestions}問',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (isParentChild && winnerTicket != null) ...[
              const SizedBox(height: AppConstants.kSpacing24),
              AnimatedOpacity(
                opacity: _showEffect ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                child: Column(
                  children: [
                    Icon(Icons.auto_awesome, size: 48, color: Colors.amber),
                    const SizedBox(height: 8),
                    Text(
                      '$winnerNameの勝ち！',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    // ご褒美券アイコン（将来的にカスタム画像に変更予定）
                    Icon(Icons.card_giftcard, size: 40, color: Colors.orange),
                    const SizedBox(height: 4),
                    Text(
                      winnerTicket.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      winnerTicket.description,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppConstants.kSpacing24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ホームに戻る'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveHistory(String winner, RewardTicket ticket) async {
    final history = RewardTicketHistory(
      winner: winner,
      ticketId: ticket.id,
      ticketName: ticket.name,
      used: false,
      playedAt: DateTime.now(),
      usedAt: null,
    );
    await RewardTicketDbHelper().insertHistory(history);
  }

  /// ゲーム終了確認ダイアログを表示
  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ゲームを終了しますか？'),
        content: const Text('現在のゲームは保存されません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // ダイアログを閉じる
              Navigator.of(context).pop(); // 画面を閉じる
            },
            child: const Text('終了'),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant GamePlayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ゲーム終了時に演出・サウンド再生
    final gameProvider = context.read<GameProvider>();
    if (!gameProvider.isGameActive && !_showEffect) {
      setState(() => _showEffect = true);
      // _audioPlayer.play(AssetSource('sounds/win.mp3'));
    }
  }
}
