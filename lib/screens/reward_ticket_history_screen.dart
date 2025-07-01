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
      appBar: AppBar(title: const Text('ご褒美券の履歴')),
      body: FutureBuilder<List<RewardTicketHistory>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('履歴がありません'));
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
                title: Text(history.ticketName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('勝者: ${history.winner == 'parent' ? '親' : '子ども'}'),
                    Text(
                      '日付: ${history.playedAt.toLocal().toString().split(" ")[0]}',
                    ),
                    if (history.used && history.usedAt != null)
                      Text(
                        '使用日: ${history.usedAt!.toLocal().toString().split(" ")[0]}',
                      ),
                  ],
                ),
                trailing: history.used
                    ? const Text('使用済み', style: TextStyle(color: Colors.grey))
                    : ElevatedButton(
                        onPressed: () => _markAsUsed(history.id!),
                        child: const Text('使う'),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
