import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/reward_ticket_history.dart';

/// ご褒美券履歴DBヘルパー
class RewardTicketDbHelper {
  static final RewardTicketDbHelper _instance =
      RewardTicketDbHelper._internal();
  factory RewardTicketDbHelper() => _instance;
  RewardTicketDbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'reward_ticket_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reward_ticket_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            winner TEXT,
            ticketId TEXT,
            ticketName TEXT,
            used INTEGER,
            playedAt TEXT,
            usedAt TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertHistory(RewardTicketHistory history) async {
    final db = await database;
    return await db.insert('reward_ticket_history', history.toMap());
  }

  Future<List<RewardTicketHistory>> getAllHistories() async {
    final db = await database;
    final maps = await db.query(
      'reward_ticket_history',
      orderBy: 'playedAt DESC',
    );
    return maps.map((map) => RewardTicketHistory.fromMap(map)).toList();
  }

  Future<void> updateUsed(
    int id, {
    required bool used,
    DateTime? usedAt,
  }) async {
    final db = await database;
    await db.update(
      'reward_ticket_history',
      {'used': used ? 1 : 0, 'usedAt': usedAt?.toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete('reward_ticket_history');
  }
}
