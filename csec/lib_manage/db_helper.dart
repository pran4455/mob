import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'library.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            author TEXT,
            isBorrowed INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertBook(String title, String author) async {
    final dbClient = await db;
    await dbClient.insert('books', {
      'title': title,
      'author': author,
      'isBorrowed': 0,
    });
  }

  static Future<List<Map<String, dynamic>>> getBooks() async {
    final dbClient = await db;
    return dbClient.query('books');
  }

  static Future<void> updateBorrowStatus(int id, int isBorrowed) async {
    final dbClient = await db;
    await dbClient.update('books', {'isBorrowed': isBorrowed}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteBook(int id) async {
    final dbClient = await db;
    await dbClient.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}
