import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import '../utils/math_problem_generator.dart';
import '../widgets/game_header.dart';
import '../widgets/problem_display.dart';
import '../widgets/correct_answer_overlay.dart';
import '../models/reward_ticket.dart';
import '../utils/reward_ticket_db_helper.dart';
import '../models/reward_ticket_history.dart';
// import 'package:audioplayers/audioplayers.dart';

/// ゲームプレイ画面
class GamePlayScreen extends StatefulWidget {
  final MathCategory category;
  final DifficultyLevel difficulty;
  final GameMode gameMode;
  // 親子対戦時のご褒美券（nullなら通常モード）
  final RewardTicket? parentTicket;
  final RewardTicket? childTicket;

  const GamePlayScreen({
    super.key,
    required this.category,
    required this.difficulty,
    required this.gameMode,
    this.parentTicket,
    this.childTicket,
  });

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  Timer? _timer;
  // final AudioPlayer _audioPlayer = AudioPlayer();
  bool _showEffect = false;
  bool _historySaved = false;

  @override
  void initState() {
    super.initState();

    // ゲーム開始（既にゲームが開始されていない場合のみ）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameProvider = context.read<GameProvider>();
      if (!gameProvider.isGameActive) {
        gameProvider.startGame(
          category: widget.category,
          difficulty: widget.difficulty,
          gameMode: widget.gameMode,
        );

        // タイマー開始（タイムアタックモードのみ）
        if (widget.gameMode == GameMode.timeAttack) {
          _startTimer();
        }
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('ゲーム'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitDialog(),
        ),
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          // ゲームが終了している場合は結果画面を表示
          if (!gameProvider.isGameActive) {
            _timer?.cancel();
            return _buildGameEndScreen(gameProvider);
          }

          return Stack(
            children: [
              Column(
                children: [
                  // ゲームヘッダー（スコア、時間など）
                  GameHeader(
                    correctAnswers: gameProvider.correctAnswers,
                    totalQuestions: gameProvider.totalQuestions,
                    remainingTime: gameProvider.remainingTime,
                    gameMode: gameProvider.gameMode,
                  ),

                  const SizedBox(height: AppConstants.kSpacing24),

                  // 問題表示
                  Expanded(
                    child: ProblemDisplay(
                      problem: gameProvider.currentProblem,
                      userAnswer: gameProvider.selectedAnswer?.toString() ?? '',
                      showCorrectAnswer: gameProvider.showCorrectAnswer,
                      onAnswerSelected: (answer) {
                        gameProvider.selectAnswer(answer);
                        // 選択と同時に回答を送信
                        gameProvider.submitAnswer(answer);
                      },
                      onAnimationComplete: () {},
                    ),
                  ),

                  const SizedBox(height: AppConstants.kSpacing16),
                ],
              ),
              // 正解オーバーレイ
              if (gameProvider.showCorrectAnswer)
                CorrectAnswerOverlay(
                  isCorrect:
                      gameProvider.selectedAnswer ==
                      gameProvider.currentProblem?.correctAnswer,
                  visible: true,
                  correctAnswer: gameProvider.currentProblem?.correctAnswer,
                ),
            ],
          );
        },
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
  void _showExitDialog() {
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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
