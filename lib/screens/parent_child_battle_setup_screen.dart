import 'package:flutter/material.dart';
import 'generic_battle_setup_screen.dart';

/// おやこ対戦設定画面
class ParentChildBattleSetupScreen extends StatelessWidget {
  const ParentChildBattleSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBattleSetupScreen(
      title: 'おやこたいせん',
      subtitle: 'おやとこどもでこうごにもんだいをといてしょうぶしよう！',
      player1Label: 'おやのなまえ',
      player2Label: 'こどものなまえ',
      player1DefaultName: 'おや',
      player2DefaultName: 'こども',
      battleSettingsTitle: 'たいせんのせってい',
      calculationCategoryLabel: 'けいさんのしゅるい',
      difficultyLabel: 'むずかしさ',
      questionCountLabel: 'もんだいのかず',
      startButtonText: 'たいせんをかいし',
      exitDialogTitle: 'ゲームをしゅうりょうしますか？',
      exitDialogContent: 'げんざいのゲームはほぞんされません。',
      homeButtonText: 'ホームにもどる',
      rematchButtonText: 'もういちどたいせん',
      battleResultTitle: 'たいせんけっか',
      winnerLabel: 'しょうしゃ',
      scoreLabel: 'スコア',
      drawText: 'ひきわけ！',
      vsText: 'VS',
      currentPlayerText: 'にんめ',
      isParentChildBattle: true,
    );
  }
}
