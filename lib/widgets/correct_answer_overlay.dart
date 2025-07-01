import 'package:flutter/material.dart';

/// 正解・不正解オーバーレイ（共通）
class CorrectAnswerOverlay extends StatefulWidget {
  final bool isCorrect;
  final int? correctAnswer;
  final VoidCallback? onAnimationEnd;
  final String correctImagePath;
  final String incorrectImagePath;

  const CorrectAnswerOverlay({
    super.key,
    required this.isCorrect,
    this.correctAnswer,
    this.onAnimationEnd,
    this.correctImagePath = 'assets/images/hero_correct.png',
    this.incorrectImagePath = 'assets/images/hero_incorrect.png',
  });

  @override
  State<CorrectAnswerOverlay> createState() => _CorrectAnswerOverlayState();
}

class _CorrectAnswerOverlayState extends State<CorrectAnswerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _controller.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        widget.onAnimationEnd?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scale,
              child: Image.asset(
                widget.isCorrect
                    ? widget.correctImagePath
                    : widget.incorrectImagePath,
                width: 240,
                height: 240,
                fit: BoxFit.contain,
              ),
            ),
            if (!widget.isCorrect && widget.correctAnswer != null) ...[
              const SizedBox(height: 24),
              Text(
                '正解は ${widget.correctAnswer}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [const Shadow(color: Colors.black, blurRadius: 8)],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
