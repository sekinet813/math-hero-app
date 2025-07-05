import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// 数字パッドウィジェット
class NumberPad extends StatelessWidget {
  final String userAnswer;
  final Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onClearPressed;
  final VoidCallback onSubmitPressed;

  const NumberPad({
    super.key,
    required this.userAnswer,
    required this.onNumberPressed,
    required this.onDeletePressed,
    required this.onClearPressed,
    required this.onSubmitPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.kSpacing16),
      child: Column(
        children: [
          // 数字ボタン
          for (int row = 0; row < 3; row++)
            Row(
              children: [
                for (int col = 0; col < 3; col++)
                  Expanded(
                    child: _buildNumberButton(
                      context,
                      (row * 3 + col + 1).toString(),
                    ),
                  ),
              ],
            ),

          // 0、削除、クリア、送信ボタン
          Row(
            children: [
              Expanded(child: _buildNumberButton(context, '0')),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.backspace,
                  onPressed: onDeletePressed,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.clear,
                  onPressed: onClearPressed,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.check,
                  onPressed: userAnswer.isNotEmpty ? onSubmitPressed : null,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 数字ボタンを構築
  Widget _buildNumberButton(BuildContext context, String number) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 60,
        child: FilledButton(
          onPressed: () => onNumberPressed(number),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.kBorderRadius8),
            ),
          ),
          child: Text(
            number,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// アクションボタンを構築
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 60,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.kBorderRadius8),
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
