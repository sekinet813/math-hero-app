import 'package:flutter/material.dart';
import '../utils/reward_ticket_presets.dart';
import '../models/reward_ticket.dart';
import '../screens/game_play_screen.dart';
import '../utils/math_problem_generator.dart'
    show MathCategory, DifficultyLevel;
import '../providers/game_provider.dart' show GameMode;

/// 親子対戦 ご褒美券選択画面
class ParentChildBattleScreen extends StatefulWidget {
  const ParentChildBattleScreen({super.key});

  @override
  State<ParentChildBattleScreen> createState() =>
      _ParentChildBattleScreenState();
}

class _ParentChildBattleScreenState extends State<ParentChildBattleScreen> {
  RewardTicket? _selectedParentTicket;
  RewardTicket? _selectedChildTicket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('親子対戦 ご褒美券選択')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '親が選ぶご褒美券',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTicketSelector(parentRewardTickets, _selectedParentTicket, (
              ticket,
            ) {
              setState(() => _selectedParentTicket = ticket);
            }),
            const SizedBox(height: 24),
            const Text(
              '子どもが選ぶご褒美券',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTicketSelector(childRewardTickets, _selectedChildTicket, (
              ticket,
            ) {
              setState(() => _selectedChildTicket = ticket);
            }),
            const Spacer(),
            ElevatedButton(
              onPressed:
                  _selectedParentTicket != null && _selectedChildTicket != null
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GamePlayScreen(
                            category: MathCategory.addition,
                            difficulty: DifficultyLevel.easy,
                            gameMode: GameMode.timeAttack,
                            parentTicket: _selectedParentTicket,
                            childTicket: _selectedChildTicket,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('対戦開始'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketSelector(
    List<RewardTicket> tickets,
    RewardTicket? selected,
    ValueChanged<RewardTicket> onSelect,
  ) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tickets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          final isSelected = selected?.id == ticket.id;
          return GestureDetector(
            onTap: () => onSelect(ticket),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: isSelected ? Colors.amber[200] : Colors.white,
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ご褒美券アイコン（将来的にカスタム画像に変更予定）
                  Icon(
                    Icons.card_giftcard,
                    size: 32,
                    color: isSelected ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ticket.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(
                    child: Text(
                      ticket.description,
                      style: const TextStyle(fontSize: 9),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
