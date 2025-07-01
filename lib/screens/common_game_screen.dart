import 'package:flutter/material.dart';
import '../models/math_problem.dart';
import '../utils/constants.dart';
import '../widgets/problem_display.dart';
import '../widgets/correct_answer_overlay.dart';
import '../widgets/game_header.dart';
import '../providers/game_provider.dart';

/// 4択問題共通ゲーム画面
class CommonGameScreen extends StatelessWidget {
  final MathProblem? currentProblem;
  final String userAnswer;
  final bool showCorrectAnswer;
  final Function(int) onAnswerSelected;
  final VoidCallback? onAnimationComplete;

  // ヘッダー情報
  final Widget? customHeader;
  final int? correctAnswers;
  final int? totalQuestions;
  final int? remainingTime;
  final GameMode? gameMode;

  // オーバーレイ情報
  final bool showOverlay;
  final bool isCorrect;
  final int? correctAnswer;
  final VoidCallback? onOverlayAnimationEnd;

  const CommonGameScreen({
    super.key,
    required this.currentProblem,
    required this.userAnswer,
    required this.showCorrectAnswer,
    required this.onAnswerSelected,
    this.onAnimationComplete,
    this.customHeader,
    this.correctAnswers,
    this.totalQuestions,
    this.remainingTime,
    this.gameMode,
    this.showOverlay = false,
    this.isCorrect = false,
    this.correctAnswer,
    this.onOverlayAnimationEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // カスタムヘッダーまたはデフォルトヘッダー
            if (customHeader != null)
              customHeader!
            else if (correctAnswers != null &&
                totalQuestions != null &&
                gameMode != null)
              GameHeader(
                correctAnswers: correctAnswers!,
                totalQuestions: totalQuestions!,
                remainingTime: remainingTime ?? 0,
                gameMode: gameMode ?? GameMode.timeAttack,
              ),
            const SizedBox(height: AppConstants.kSpacing24),
            // 問題表示
            Expanded(
              child: ProblemDisplay(
                problem: currentProblem,
                userAnswer: userAnswer,
                showCorrectAnswer: showCorrectAnswer,
                onAnswerSelected: onAnswerSelected,
                onAnimationComplete: onAnimationComplete,
              ),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
          ],
        ),
        // 正解・不正解オーバーレイ
        if (showOverlay)
          CorrectAnswerOverlay(
            isCorrect: isCorrect,
            correctAnswer: correctAnswer,
            onAnimationEnd: onOverlayAnimationEnd,
          ),
      ],
    );
  }
}
