import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'habit.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    _db ??= await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'habits.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE habits(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          date TEXT,
          completed INTEGER
        )
      ''');
    });
  }

  static Future<int> insertHabit(Habit habit) async {
    final dbClient = await db;
    return await dbClient.insert('habits', habit.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Habit>> getHabits() async {
    final dbClient = await db;
    final maps = await dbClient.query('habits');
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  static Future<int> updateHabit(Habit habit) async {
    final dbClient = await db;
    return await dbClient.update('habits', habit.toMap(), where: 'id = ?', whereArgs: [habit.id]);
  }
}
