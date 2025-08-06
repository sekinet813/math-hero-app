import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/math_problem_generator.dart';
import 'game_play_screen.dart';
import '../providers/game_provider.dart';

/// タイムアタック設定画面
class TimeAttackSetupScreen extends StatefulWidget {
  const TimeAttackSetupScreen({super.key});

  @override
  State<TimeAttackSetupScreen> createState() => _TimeAttackSetupScreenState();
}

class _TimeAttackSetupScreenState extends State<TimeAttackSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  MathCategory _selectedCategory = MathCategory.addition;
  DifficultyLevel _selectedDifficulty = DifficultyLevel.easy;
  int _selectedTimeLimit = AppConstants.kDefaultTimeLimit;

  final List<int> _timeOptions = [30, 60, 90];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャレンジせってい'),
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
              Text(
                'チャレンジ',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing8),
              Text(
                'まちがえるまでチャレンジしよう！',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.kSpacing32),
              _buildTimeLimitSection(),
              const SizedBox(height: AppConstants.kSpacing24),
              _buildCategorySection(),
              const SizedBox(height: AppConstants.kSpacing24),
              _buildDifficultySection(),
              const SizedBox(height: 32),
              FilledButton(onPressed: _startGame, child: const Text('スタート')),
            ],
          ),
        ),
      ),
    );
  }

  /// 制限時間選択セクション
  Widget _buildTimeLimitSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.kSpacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'じかん',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            DropdownButtonFormField<int>(
              value: _selectedTimeLimit,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: _timeOptions
                  .map((t) => DropdownMenuItem(value: t, child: Text('$t びょう')))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTimeLimit = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// カテゴリ選択セクション
  Widget _buildCategorySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.kSpacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'けいさんのしゅるい',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
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
          ],
        ),
      ),
    );
  }

  /// 難易度選択セクション
  Widget _buildDifficultySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.kSpacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'むずかしさ',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
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
          ],
        ),
      ),
    );
  }

  /// ゲーム開始
  void _startGame() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GamePlayScreen(
            category: _selectedCategory,
            difficulty: _selectedDifficulty,
            gameMode: GameMode.timeAttack,
            timeLimit: _selectedTimeLimit,
          ),
        ),
      );
    }
  }
}
