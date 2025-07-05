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
                'きょうだい・ともだちたいせん',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing8),
              Text(
                'おなじたんまつでこうごにもんだいをといてしょうぶしよう！',
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
              const Spacer(),
              // 開始ボタン
              FilledButton(
                onPressed: _startBattle,
                child: const Text('たいせんをかいし'),
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
              decoration: const InputDecoration(
                labelText: '1にんめのなまえ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
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
              decoration: const InputDecoration(
                labelText: '2にんめのなまえ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
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
              'たいせんのせってい',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // 計算カテゴリ
            Text(
              'けいさんのしゅるい',
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
              'むずかしさ',
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
              'もんだいのかず',
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

    // 対戦画面に遷移
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const BattleScreen()));
  }
}
