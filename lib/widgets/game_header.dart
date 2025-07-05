import 'package:flutter/material.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';

/// ゲームヘッダーウィジェット
class GameHeader extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final int remainingTime;
  final GameMode gameMode;

  const GameHeader({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.remainingTime,
    required this.gameMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.kSpacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppConstants.kBorderRadius12),
      ),
      child: Row(
        children: [
          // 正解数
          Expanded(
            child: _buildStatItem(
              context,
              icon: Icons.check_circle,
              label: 'せいかい',
              value: '$correctAnswers',
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // 総問題数
          Expanded(
            child: _buildStatItem(
              context,
              icon: Icons.quiz,
              label: 'もんだい',
              value: '$totalQuestions',
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          // 残り時間（タイムアタックモードのみ）
          if (gameMode == GameMode.timeAttack)
            Expanded(
              child: _buildStatItem(
                context,
                icon: Icons.timer,
                label: 'のこりじかん',
                value: '{$remainingTime}びょう',
                color: remainingTime <= 10
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.tertiary,
              ),
            ),
        ],
      ),
    );
  }

  /// 統計アイテムを構築
  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
