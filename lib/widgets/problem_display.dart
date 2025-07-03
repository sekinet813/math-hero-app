import 'package:flutter/material.dart';
import '../models/math_problem.dart';
import '../utils/constants.dart';

/// 問題表示ウィジェット
class ProblemDisplay extends StatefulWidget {
  final MathProblem? problem;
  final String userAnswer;
  final bool showCorrectAnswer;
  final VoidCallback? onAnimationComplete;
  final Function(int) onAnswerSelected;

  const ProblemDisplay({
    super.key,
    required this.problem,
    required this.userAnswer,
    required this.showCorrectAnswer,
    required this.onAnswerSelected,
    this.onAnimationComplete,
  });

  @override
  State<ProblemDisplay> createState() => _ProblemDisplayState();
}

class _ProblemDisplayState extends State<ProblemDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  List<int> _choices = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _colorAnimation = ColorTween(begin: Colors.green, end: Colors.transparent)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    // 初回描画時にも選択肢をセット
    if (widget.problem != null) {
      _updateChoices();
    }
  }

  @override
  void didUpdateWidget(ProblemDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 問題が変わったら選択肢を更新
    if (widget.problem != oldWidget.problem) {
      _updateChoices();
    }

    // 正解が表示されたらアニメーション開始
    if (widget.showCorrectAnswer && !oldWidget.showCorrectAnswer) {
      _animationController.forward().then((_) {
        _animationController.reverse();
        widget.onAnimationComplete?.call();
      });
    }
  }

  /// 選択肢を更新
  void _updateChoices() {
    if (widget.problem != null) {
      _choices = widget.problem!.generateChoices();
    } else {
      _choices = [];
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 問題文
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.kSpacing32),
                  decoration: BoxDecoration(
                    color: _colorAnimation.value ?? Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      AppConstants.kBorderRadius12,
                    ),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    widget.problem!.questionText,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppConstants.kSpacing32),

          // 選択肢ボタン
          if (_choices.length >= 4) ...[
            Column(
              children: [
                // 上段の選択肢
                Row(
                  children: [
                    Expanded(child: _buildChoiceButton(context, _choices[0])),
                    const SizedBox(width: AppConstants.kSpacing16),
                    Expanded(child: _buildChoiceButton(context, _choices[1])),
                  ],
                ),
                const SizedBox(height: AppConstants.kSpacing16),
                // 下段の選択肢
                Row(
                  children: [
                    Expanded(child: _buildChoiceButton(context, _choices[2])),
                    const SizedBox(width: AppConstants.kSpacing16),
                    Expanded(child: _buildChoiceButton(context, _choices[3])),
                  ],
                ),
              ],
            ),
          ] else ...[
            // 選択肢が準備できていない場合のローディング表示
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  /// 選択肢ボタンを構築
  Widget _buildChoiceButton(BuildContext context, int choice) {
    final isSelected =
        widget.userAnswer == choice.toString() && !widget.showCorrectAnswer;
    final isCorrect = choice == widget.problem!.correctAnswer;
    final showResult = widget.showCorrectAnswer;

    Color backgroundColor;
    Color textColor;

    if (showResult) {
      if (isCorrect) {
        backgroundColor = Colors.green;
        textColor = Colors.white;
      } else if (widget.userAnswer == choice.toString()) {
        backgroundColor = Colors.red;
        textColor = Colors.white;
      } else {
        backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
        textColor = Theme.of(context).colorScheme.onSurfaceVariant;
      }
    } else {
      backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      textColor = Theme.of(context).colorScheme.onSurfaceVariant;
      if (isSelected) {
        backgroundColor = Theme.of(context).colorScheme.primary;
        textColor = Colors.white;
      }
    }

    return SizedBox(
      height: 80,
      child: FilledButton(
        onPressed: showResult ? null : () => widget.onAnswerSelected(choice),
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.kBorderRadius12),
          ),
        ),
        child: Text(
          choice.toString(),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
