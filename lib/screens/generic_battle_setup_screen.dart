import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/battle_provider.dart';
import '../utils/constants.dart';
import '../utils/math_problem_generator.dart';
import 'generic_battle_screen.dart';
import 'parent_child_battle_selection_screen.dart';

/// 汎用的な対戦設定画面
class GenericBattleSetupScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String player1Label;
  final String player2Label;
  final String player1DefaultName;
  final String player2DefaultName;
  final String battleSettingsTitle;
  final String calculationCategoryLabel;
  final String difficultyLabel;
  final String questionCountLabel;
  final String startButtonText;
  final String exitDialogTitle;
  final String exitDialogContent;
  final String homeButtonText;
  final String rematchButtonText;
  final String battleResultTitle;
  final String winnerLabel;
  final String scoreLabel;
  final String drawText;
  final String vsText;
  final String currentPlayerText;
  final bool isParentChildBattle;

  const GenericBattleSetupScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.player1Label,
    required this.player2Label,
    required this.player1DefaultName,
    required this.player2DefaultName,
    required this.battleSettingsTitle,
    required this.calculationCategoryLabel,
    required this.difficultyLabel,
    required this.questionCountLabel,
    required this.startButtonText,
    required this.exitDialogTitle,
    required this.exitDialogContent,
    required this.homeButtonText,
    required this.rematchButtonText,
    required this.battleResultTitle,
    required this.winnerLabel,
    required this.scoreLabel,
    required this.drawText,
    required this.vsText,
    required this.currentPlayerText,
    this.isParentChildBattle = false,
  });

  @override
  State<GenericBattleSetupScreen> createState() =>
      _GenericBattleSetupScreenState();
}

class _GenericBattleSetupScreenState extends State<GenericBattleSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();

  MathCategory _selectedCategory = MathCategory.addition;
  DifficultyLevel _selectedDifficulty = DifficultyLevel.easy;
  int _questionsPerPlayer = 5;

  @override
  void initState() {
    super.initState();
    // デフォルト名を設定
    _player1Controller.text = widget.player1DefaultName;
    _player2Controller.text = widget.player2DefaultName;
  }

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.kSpacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppConstants.kSpacing16),
              // タイトル
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing8),
              Text(
                widget.subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing32),
              // プレイヤー名入力
              _buildPlayerNameSection(),
              const SizedBox(height: AppConstants.kSpacing24),
              // 対戦設定
              _buildBattleSettingsSection(),
              const SizedBox(height: 32),
              // 開始ボタン
              FilledButton(
                onPressed: _startBattle,
                child: Text(widget.startButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// プレイヤー名入力セクションを構築
  Widget _buildPlayerNameSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.kSpacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'プレイヤーめい',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            TextFormField(
              controller: _player1Controller,
              decoration: InputDecoration(
                labelText: widget.player1Label,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'なまえをにゅうりょくしてください';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            TextFormField(
              controller: _player2Controller,
              decoration: InputDecoration(
                labelText: widget.player2Label,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'なまえをにゅうりょくしてください';
                }
                if (value.trim() == _player1Controller.text.trim()) {
                  return 'ことなるなまえをにゅうりょくしてください';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 対戦設定セクションを構築
  Widget _buildBattleSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.kSpacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.battleSettingsTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // 計算カテゴリ
            Text(
              widget.calculationCategoryLabel,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 14),
            ),
            const SizedBox(height: AppConstants.kSpacing8),
            DropdownButtonFormField<MathCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(
                  value: MathCategory.addition,
                  child: Text('たしざん'),
                ),
                DropdownMenuItem(
                  value: MathCategory.subtraction,
                  child: Text('ひきざん'),
                ),
                DropdownMenuItem(
                  value: MathCategory.multiplication,
                  child: Text('かけざん'),
                ),
                DropdownMenuItem(
                  value: MathCategory.division,
                  child: Text('わりざん'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // 難易度
            Text(
              widget.difficultyLabel,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 14),
            ),
            const SizedBox(height: AppConstants.kSpacing8),
            DropdownButtonFormField<DifficultyLevel>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(
                  value: DifficultyLevel.easy,
                  child: Text('かんたん'),
                ),
                DropdownMenuItem(
                  value: DifficultyLevel.medium,
                  child: Text('ふつう'),
                ),
                DropdownMenuItem(
                  value: DifficultyLevel.hard,
                  child: Text('むずかしい'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDifficulty = value;
                  });
                }
              },
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // 問題数
            Text(
              widget.questionCountLabel,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 14),
            ),
            const SizedBox(height: AppConstants.kSpacing8),
            DropdownButtonFormField<int>(
              value: _questionsPerPlayer,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 3, child: Text('3もん')),
                DropdownMenuItem(value: 5, child: Text('5もん')),
                DropdownMenuItem(value: 10, child: Text('10もん')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _questionsPerPlayer = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 対戦を開始
  void _startBattle() {
    if (!_formKey.currentState!.validate()) return;

    final battleProvider = context.read<BattleProvider>();

    // プレイヤー名を設定
    battleProvider.setPlayerNames(
      _player1Controller.text.trim(),
      _player2Controller.text.trim(),
    );

    // 対戦設定を更新
    battleProvider.updateBattleSettings(
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
      questionsPerPlayer: _questionsPerPlayer,
    );

    // 親子対戦の場合はご褒美選択画面に遷移
    if (widget.isParentChildBattle) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ParentChildBattleSelectionScreen(),
        ),
      );
    } else {
      // 通常の対戦画面に遷移
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GenericBattleScreen(
            title: widget.title,
            player1Label: widget.player1Label,
            player2Label: widget.player2Label,
            exitDialogTitle: widget.exitDialogTitle,
            exitDialogContent: widget.exitDialogContent,
            homeButtonText: widget.homeButtonText,
            rematchButtonText: widget.rematchButtonText,
            battleResultTitle: widget.battleResultTitle,
            winnerLabel: widget.winnerLabel,
            scoreLabel: widget.scoreLabel,
            drawText: widget.drawText,
            vsText: widget.vsText,
            currentPlayerText: widget.currentPlayerText,
          ),
        ),
      );
    }
  }
}
