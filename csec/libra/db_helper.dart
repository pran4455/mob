import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> _getDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'shopping.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<void> addProduct(String name, double price) async {
    final db = await _getDB();
    await db.insert('products', {'name': name, 'price': price});
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await _getDB();
    return db.query('products', orderBy: 'id DESC');
  }

  static Future<void> updateProduct(int id, String name, double price) async {
    final db = await _getDB();
    await db.update('products', {'name': name, 'price': price}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteProduct(int id) async {
    final db = await _getDB();
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
