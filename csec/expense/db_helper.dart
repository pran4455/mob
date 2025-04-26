import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expenses.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            date TEXT
          )
        ''');
      },
    );
  }

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<void> insertExpense(String title, double amount, DateTime date) async {
    final dbClient = await db;
    await dbClient.insert('expenses', {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getExpenses() async {
    final dbClient = await db;
    return dbClient.query('expenses', orderBy: 'date DESC');
  }

  static Future<void> deleteExpense(int id) async {
    final dbClient = await db;
    await dbClient.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}
