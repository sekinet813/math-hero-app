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
              child: CustomPaint(
                size: const Size(120, 120),
                painter: _MaruPainter(
                  color: Colors.red, // 赤色
                  strokeWidth: 8, // 細め
                ),
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

class _MaruPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _MaruPainter({required this.color, this.strokeWidth = 8});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final double radius =
        (size.width < size.height ? size.width : size.height) / 2 - strokeWidth;
    final Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
