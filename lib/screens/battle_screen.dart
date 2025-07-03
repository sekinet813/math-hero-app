import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/battle_provider.dart';
import '../utils/constants.dart';
import '../models/math_problem.dart';
import 'common_game_screen.dart';

/// フレンド対戦画面
class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  String _userAnswer = '';
  MathProblem? _lastProblem;

  @override
  void initState() {
    super.initState();
    // 対戦を開始
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BattleProvider>().startBattle();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.watch<BattleProvider>();
    // 問題が切り替わったらuserAnswerをリセット
    if (_lastProblem != provider.currentProblem) {
      setState(() {
        _userAnswer = '';
        _lastProblem = provider.currentProblem;
      });
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('フレンド対戦'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitDialog(context),
        ),
      ),
      body: Consumer<BattleProvider>(
        builder: (context, battleProvider, child) {
          if (battleProvider.isBattleFinished) {
            return _buildBattleResult(context, battleProvider);
          }

          final showOverlay = battleProvider.showCorrectAnswer;
          final isCorrect =
              battleProvider.selectedAnswer ==
              battleProvider.currentProblem?.correctAnswer;

          return CommonGameScreen(
            currentProblem: battleProvider.currentProblem,
            userAnswer: _userAnswer,
            showCorrectAnswer: battleProvider.showCorrectAnswer,
            onAnswerSelected: (answer) {
              setState(() {
                _userAnswer = answer.toString();
              });
              battleProvider.selectAnswer(answer);
              battleProvider.submitAnswer(answer);
            },
            customHeader: _buildBattleHeader(context, battleProvider),
            showOverlay: showOverlay,
            isCorrect: isCorrect,
            correctAnswer: battleProvider.currentProblem?.correctAnswer,
            onOverlayAnimationEnd: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }

  /// 対戦情報ヘッダーを構築
  Widget _buildBattleHeader(
    BuildContext context,
    BattleProvider battleProvider,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.kSpacing16),
        child: Column(
          children: [
            // プレイヤー情報
            Row(
              children: [
                Expanded(
                  child: _buildPlayerInfo(
                    context,
                    battleProvider.player1Name,
                    battleProvider.player1Score,
                    battleProvider.currentPlayerIndex == 0,
                  ),
                ),
                const Text(
                  'VS',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: _buildPlayerInfo(
                    context,
                    battleProvider.player2Name,
                    battleProvider.player2Score,
                    battleProvider.currentPlayerIndex == 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.kSpacing8),
            // 進捗情報
            Text(
              '${battleProvider.currentPlayerIndex + 1}にんめ: ${battleProvider.currentQuestionIndex + 1}/${battleProvider.questionsPerPlayer}もんめ',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// プレイヤー情報を構築
  Widget _buildPlayerInfo(
    BuildContext context,
    String name,
    int score,
    bool isCurrentPlayer,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.kSpacing8),
      decoration: BoxDecoration(
        color: isCurrentPlayer
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: isCurrentPlayer ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          Text(
            '$scoreてん',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// 対戦結果画面を構築
  Widget _buildBattleResult(
    BuildContext context,
    BattleProvider battleProvider,
  ) {
    final match = battleProvider.currentMatch;
    if (match == null) return const SizedBox.shrink();

    final isDraw = match.winner == '引き分け';
    final winnerName = isDraw ? null : match.winner;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.kSpacing16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 結果タイトル
          Text(
            isDraw ? 'ひきわけ！' : 'たいせんけっか',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.kSpacing32),
          // 勝者表示
          if (!isDraw) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.kSpacing24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 64,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: AppConstants.kSpacing16),
                    Text(
                      'しょうしゃ',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: AppConstants.kSpacing8),
                    Text(
                      winnerName!,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.kSpacing24),
          ],
          // スコア表示
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.kSpacing16),
              child: Column(
                children: [
                  Text(
                    'スコア',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: AppConstants.kSpacing16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildScoreDisplay(
                        context,
                        match.player1Name,
                        match.player1Score,
                        match.winner == match.player1Name,
                      ),
                      const Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildScoreDisplay(
                        context,
                        match.player2Name,
                        match.player2Score,
                        match.winner == match.player2Name,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.kSpacing32),
          // ボタン
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('ホームにもどる'),
                ),
              ),
              const SizedBox(width: AppConstants.kSpacing16),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    // 再戦機能（将来的に実装）
                    Navigator.of(context).pop();
                  },
                  child: const Text('もういちどたいせん'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// スコア表示を構築
  Widget _buildScoreDisplay(
    BuildContext context,
    String name,
    int score,
    bool isWinner,
  ) {
    return Column(
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: AppConstants.kSpacing8),
        Text(
          '$scoreてん',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: isWinner
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
