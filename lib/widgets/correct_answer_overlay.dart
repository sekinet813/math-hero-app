import 'package:flutter/material.dart';

/// 正解オーバーレイウィジェット
class CorrectAnswerOverlay extends StatelessWidget {
  final bool isCorrect;
  final bool visible;
  final int? correctAnswer;

  const CorrectAnswerOverlay({
    super.key,
    required this.isCorrect,
    required this.visible,
    this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              child: Image.asset(
                isCorrect
                    ? 'assets/images/hero_correct.png'
                    : 'assets/images/hero_incorrect.png',
                width: 240,
                height: 240,
                fit: BoxFit.contain,
              ),
            ),
            if (!isCorrect && correctAnswer != null) ...[
              const SizedBox(height: 24),
              Text(
                '正解は $correctAnswer',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
