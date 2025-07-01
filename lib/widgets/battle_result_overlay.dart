import 'package:flutter/material.dart';
import 'dart:async';

/// 対戦結果オーバーレイウィジェット
class BattleResultOverlay extends StatefulWidget {
  final bool isCorrect;
  final VoidCallback? onAnimationComplete;

  const BattleResultOverlay({
    super.key,
    required this.isCorrect,
    this.onAnimationComplete,
  });

  @override
  State<BattleResultOverlay> createState() => _BattleResultOverlayState();
}

class _BattleResultOverlayState extends State<BattleResultOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // アニメーション開始
    _animationController.forward().then((_) {
      // 少し待ってからフェードアウト
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          _animationController.reverse().then((_) {
            widget.onAnimationComplete?.call();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    widget.isCorrect
                        ? 'assets/images/hero_correct.png'
                        : 'assets/images/hero_incorrect.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
