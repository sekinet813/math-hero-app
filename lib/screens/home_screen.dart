import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/math_problem_generator.dart';
import '../providers/game_provider.dart';
import 'game_play_screen.dart';
import 'reward_ticket_history_screen.dart';
import 'parent_child_battle_screen.dart';

/// ホーム画面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('マスヒーロー'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.kSpacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppConstants.kSpacing32),
            // タイトル
            Text(
              'マスヒーロー',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.kSpacing8),
            Text(
              '楽しく計算を学ぼう！',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.kSpacing32),
            // ゲーム開始ボタン
            FilledButton(
              onPressed: () => _showGameModeDialog(context),
              child: const Text('ゲームを始める'),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // 親子対戦ボタン
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ParentChildBattleScreen(),
                  ),
                );
              },
              icon: Icon(Icons.family_restroom),
              label: Text('親子対戦'),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // 履歴ボタン
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RewardTicketHistoryScreen(),
                  ),
                );
              },
              child: const Text('履歴を見る'),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // 設定ボタン
            OutlinedButton(
              onPressed: () {
                // 設定画面の実装予定
              },
              child: const Text('設定'),
            ),
          ],
        ),
      ),
    );
  }

  /// ゲームモード選択ダイアログを表示
  void _showGameModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ゲームモードを選択'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('タイムアタック'),
              subtitle: const Text('60秒で何問解けるか挑戦！'),
              onTap: () {
                Navigator.of(context).pop();
                _showCategoryDialog(context, GameMode.timeAttack);
              },
            ),
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: const Text('エンドレス'),
              subtitle: const Text('間違えるまで続けよう！'),
              onTap: () {
                Navigator.of(context).pop();
                _showCategoryDialog(context, GameMode.endless);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// カテゴリ選択ダイアログを表示
  void _showCategoryDialog(BuildContext context, GameMode gameMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('計算カテゴリを選択'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('足し算'),
              onTap: () {
                Navigator.of(context).pop();
                _showDifficultyDialog(context, gameMode, MathCategory.addition);
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove),
              title: const Text('引き算'),
              onTap: () {
                Navigator.of(context).pop();
                _showDifficultyDialog(
                  context,
                  gameMode,
                  MathCategory.subtraction,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('掛け算'),
              onTap: () {
                Navigator.of(context).pop();
                _showDifficultyDialog(
                  context,
                  gameMode,
                  MathCategory.multiplication,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.functions),
              title: const Text('割り算'),
              onTap: () {
                Navigator.of(context).pop();
                _showDifficultyDialog(context, gameMode, MathCategory.division);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 難易度選択ダイアログを表示
  void _showDifficultyDialog(
    BuildContext context,
    GameMode gameMode,
    MathCategory category,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('難易度を選択'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sentiment_satisfied),
              title: const Text('かんたん'),
              subtitle: const Text('1桁の計算'),
              onTap: () {
                Navigator.of(context).pop();
                _startGame(context, gameMode, category, DifficultyLevel.easy);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sentiment_neutral),
              title: const Text('ふつう'),
              subtitle: const Text('繰り上がり・繰り下がりあり'),
              onTap: () {
                Navigator.of(context).pop();
                _startGame(context, gameMode, category, DifficultyLevel.medium);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sentiment_dissatisfied),
              title: const Text('むずかしい'),
              subtitle: const Text('2桁の計算'),
              onTap: () {
                Navigator.of(context).pop();
                _startGame(context, gameMode, category, DifficultyLevel.hard);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ゲームを開始
  void _startGame(
    BuildContext context,
    GameMode gameMode,
    MathCategory category,
    DifficultyLevel difficulty,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamePlayScreen(
          category: category,
          difficulty: difficulty,
          gameMode: gameMode,
        ),
      ),
    );
  }
}
