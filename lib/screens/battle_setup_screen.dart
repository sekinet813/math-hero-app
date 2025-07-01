import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/battle_provider.dart';
import '../utils/constants.dart';
import '../utils/math_problem_generator.dart';
import 'battle_screen.dart';

/// 対戦設定画面
class BattleSetupScreen extends StatefulWidget {
  const BattleSetupScreen({super.key});

  @override
  State<BattleSetupScreen> createState() => _BattleSetupScreenState();
}

class _BattleSetupScreenState extends State<BattleSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();

  MathCategory _selectedCategory = MathCategory.addition;
  DifficultyLevel _selectedDifficulty = DifficultyLevel.easy;
  int _questionsPerPlayer = 5;

  final List<String> gameModes = ['タイムアタック', 'エンドレス', 'フレンド対戦'];

  @override
  void initState() {
    super.initState();
    // デフォルト名を設定
    _player1Controller.text = 'プレイヤー1';
    _player2Controller.text = 'プレイヤー2';
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
        title: const Text('対戦設定'),
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
                '兄弟・友達対戦',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing8),
              Text(
                '同じ端末で交互に問題を解いて勝負しよう！',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing32),
              // プレイヤー名入力
              _buildPlayerNameSection(),
              const SizedBox(height: AppConstants.kSpacing24),
              // 対戦設定
              _buildBattleSettingsSection(),
              const Spacer(),
              // 開始ボタン
              FilledButton(onPressed: _startBattle, child: const Text('対戦を開始')),
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
            Text('プレイヤー名', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppConstants.kSpacing16),
            TextFormField(
              controller: _player1Controller,
              decoration: const InputDecoration(
                labelText: '1人目の名前',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '名前を入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            TextFormField(
              controller: _player2Controller,
              decoration: const InputDecoration(
                labelText: '2人目の名前',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '名前を入力してください';
                }
                if (value.trim() == _player1Controller.text.trim()) {
                  return '異なる名前を入力してください';
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
            Text('対戦設定', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppConstants.kSpacing16),
            // 計算カテゴリ
            Text('計算カテゴリ', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppConstants.kSpacing8),
            DropdownButtonFormField<MathCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(
                  value: MathCategory.addition,
                  child: Text('足し算'),
                ),
                DropdownMenuItem(
                  value: MathCategory.subtraction,
                  child: Text('引き算'),
                ),
                DropdownMenuItem(
                  value: MathCategory.multiplication,
                  child: Text('掛け算'),
                ),
                DropdownMenuItem(
                  value: MathCategory.division,
                  child: Text('割り算'),
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
            Text('難易度', style: Theme.of(context).textTheme.titleMedium),
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
            Text('1人あたりの問題数', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppConstants.kSpacing8),
            DropdownButtonFormField<int>(
              value: _questionsPerPlayer,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 3, child: Text('3問')),
                DropdownMenuItem(value: 5, child: Text('5問')),
                DropdownMenuItem(value: 10, child: Text('10問')),
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

    // 対戦画面に遷移
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const BattleScreen()));
  }
}
