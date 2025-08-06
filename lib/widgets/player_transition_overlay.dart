import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// プレイヤー切り替え時のオーバーレイ
class PlayerTransitionOverlay extends StatefulWidget {
  final String playerName; // 次のプレイヤー
  final String prevPlayerName; // 前回のプレイヤー
  final int prevPlayerScore; // 前回の得点
  final VoidCallback? onStartPressed;

  const PlayerTransitionOverlay({
    super.key,
    required this.playerName,
    required this.prevPlayerName,
    required this.prevPlayerScore,
    this.onStartPressed,
  });

  @override
  State<PlayerTransitionOverlay> createState() =>
      _PlayerTransitionOverlayState();
}

class _PlayerTransitionOverlayState extends State<PlayerTransitionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
        reverseCurve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
        reverseCurve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    // アニメーション開始のみ（自動終了しない）
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.kSpacing24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.swap_horiz,
                          size: 48,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: AppConstants.kSpacing16),
                        Text(
                          'プレイヤーがかわりました！',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                        const SizedBox(height: AppConstants.kSpacing8),
                        Text(
                          '${widget.playerName}のばん！',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: AppConstants.kSpacing16),
                        // 前回プレイヤーの得点表示
                        Text(
                          '前回: ${widget.prevPlayerName} の得点: ${widget.prevPlayerScore}点',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: AppConstants.kSpacing24),
                        // 開始ボタン
                        ElevatedButton(
                          onPressed: widget.onStartPressed,
                          child: const Text('開始'),
                        ),
                      ],
                    ),
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
