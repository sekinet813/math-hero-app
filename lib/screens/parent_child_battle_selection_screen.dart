import 'package:flutter/material.dart';
import '../utils/reward_ticket_presets.dart';
import '../models/reward_ticket.dart';
import 'parent_child_battle_screen.dart';

/// 親子対戦 ご褒美券選択画面
class ParentChildBattleSelectionScreen extends StatefulWidget {
  const ParentChildBattleSelectionScreen({super.key});

  @override
  State<ParentChildBattleSelectionScreen> createState() =>
      _ParentChildBattleSelectionScreenState();
}

class _ParentChildBattleSelectionScreenState
    extends State<ParentChildBattleSelectionScreen> {
  RewardTicket? _selectedParentTicket;
  RewardTicket? _selectedChildTicket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('おやこたいせん ごほうびけん')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'おやじがえらぶごほうび',
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
              'こどもがえらぶごほうび',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTicketSelector(childRewardTickets, _selectedChildTicket, (
              ticket,
            ) {
              setState(() => _selectedChildTicket = ticket);
            }),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed:
                  _selectedParentTicket != null && _selectedChildTicket != null
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ParentChildBattleScreen(
                            parentTicket: _selectedParentTicket!,
                            childTicket: _selectedChildTicket!,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('たいせんをかいし'),
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
              width: 140,
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
                  Icon(
                    Icons.card_giftcard,
                    size: 32,
                    color: isSelected ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ticket.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(
                    child: Text(
                      ticket.description,
                      style: const TextStyle(fontSize: 13),
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
