import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/math_problem_generator.dart';
import '../providers/game_provider.dart';
import 'game_play_screen.dart';
import 'battle_setup_screen.dart';
import 'parent_child_battle_setup_screen.dart';

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
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.kSpacing8),
            Text(
              'たのしくけいさんをまなぼう！',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.kSpacing32),
            // ゲーム開始ボタン
            FilledButton(
              onPressed: () => _showGameModeDialog(context),
              child: const Text('ゲームをはじめる'),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // フレンド対戦ボタン
            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BattleSetupScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.people),
              label: const Text('フレンドたいせん'),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // 親子対戦ボタン
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ParentChildBattleSetupScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.family_restroom),
              label: const Text('おやこたいせん'),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // TODO: 履歴ボタンを実装する
            // 履歴ボタン
            /*
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RewardTicketHistoryScreen(),
                  ),
                );
              },
              child: const Text('れきしをみる'),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            */
            /*
            // 設定ボタン
            OutlinedButton(
              onPressed: () {
                // 設定画面の実装予定
              },
              child: const Text('せってい'),
            ),
            */
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
        title: const Text('ゲームモードをえらぶ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('タイムアタック'),
              subtitle: const Text('60びょうでなんもんとけるかちょうせん！'),
              onTap: () {
                Navigator.of(context).pop();
                _showCategoryDialog(context, GameMode.timeAttack);
              },
            ),
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: const Text('チャレンジ'),
              subtitle: const Text('まちがえるまでつづけよう！'),
              onTap: () {
                Navigator.of(context).pop();
                _showCategoryDialog(context, GameMode.challenge);
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
        title: const Text('けいさんのしゅるいをえらぶ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('たしざん'),
              onTap: () {
                Navigator.of(context).pop();
                _showDifficultyDialog(context, gameMode, MathCategory.addition);
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove),
              title: const Text('ひきざん'),
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
              title: const Text('かけざん'),
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
              title: const Text('わりざん'),
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
        title: const Text('むずかしさをえらぶ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sentiment_satisfied),
              title: const Text('かんたん'),
              subtitle: const Text('1けたのけいさん'),
              onTap: () {
                Navigator.of(context).pop();
                _startGame(context, gameMode, category, DifficultyLevel.easy);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sentiment_neutral),
              title: const Text('ふつう'),
              subtitle: const Text('くりあがり・くりさがりあり'),
              onTap: () {
                Navigator.of(context).pop();
                _startGame(context, gameMode, category, DifficultyLevel.medium);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sentiment_dissatisfied),
              title: const Text('むずかしい'),
              subtitle: const Text('2けたのけいさん'),
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
