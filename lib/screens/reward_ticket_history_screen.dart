import 'package:flutter/material.dart';
import '../utils/reward_ticket_db_helper.dart';
import '../models/reward_ticket_history.dart';

/// ご褒美券履歴一覧画面
class RewardTicketHistoryScreen extends StatefulWidget {
  const RewardTicketHistoryScreen({super.key});

  @override
  State<RewardTicketHistoryScreen> createState() =>
      _RewardTicketHistoryScreenState();
}

class _RewardTicketHistoryScreenState extends State<RewardTicketHistoryScreen> {
  late Future<List<RewardTicketHistory>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = RewardTicketDbHelper().getAllHistories();
    });
  }

  Future<void> _markAsUsed(int id) async {
    await RewardTicketDbHelper().updateUsed(
      id,
      used: true,
      usedAt: DateTime.now(),
    );
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ごほうびけんのれきし')),
      body: FutureBuilder<List<RewardTicketHistory>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('れきしがありません', style: TextStyle(fontSize: 16)),
            );
          }
          final histories = snapshot.data!;
          return ListView.separated(
            itemCount: histories.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final history = histories[index];
              return ListTile(
                leading: Icon(
                  history.used ? Icons.check_circle : Icons.card_giftcard,
                  color: history.used ? Colors.green : Colors.orange,
                ),
                title: Text(
                  history.ticketName,
                  style: const TextStyle(fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'しょうしゃ: ${history.winner == 'parent' ? 'おや' : 'こども'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'ひづけ: ${history.playedAt.toLocal().toString().split(" ")[0]}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (history.used && history.usedAt != null)
                      Text(
                        'しようび: ${history.usedAt!.toLocal().toString().split(" ")[0]}',
                        style: const TextStyle(fontSize: 14),
                      ),
                  ],
                ),
                trailing: history.used
                    ? const Text(
                        'しようずみ',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      )
                    : ElevatedButton(
                        onPressed: () => _markAsUsed(history.id!),
                        child: const Text('つかう'),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
