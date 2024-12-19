import 'package:hedieaty2/data/repositories/database_service.dart';
import 'package:sqflite/sqflite.dart';

class UsersDB {
  final tableName = 'users';

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS users (
        ID TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        preferences TEXT NOT NULL,
        phone TEXT NOT NULL,
        image TEXT,
        numPledgedGifts INTEGER DEFAULT 0 
      );
    """);
  }

  Future<int> create({
    required String id,
    required String name,
    required String email,
    required String phone,
    String? preferences,
    String? image,
    int numPledgedGifts = 0,
  }) async {
    final database = await DatabaseService().database;

    return await database.rawInsert("""
      INSERT INTO users (id,name, email, preferences,phone, image,numPledgedGifts)
      VALUES (?,?, ?, ?,?, ?,?)
    """, [id, name, email, preferences, phone, image, numPledgedGifts]);
  }

  Future<void> incrementPledgedGiftsCount(String userId) async {
    final database = await DatabaseService().database;

    try {
      await database.rawUpdate("""
      UPDATE users
      SET numPledgedGifts = numPledgedGifts + 1
      WHERE id = ?
    """, [userId]);
    } catch (e) {
      print('Error incrementing pledged gifts count: $e');
    }
  }

  Future<int?> getPledgedGiftsCount(String userId) async {
    final database = await DatabaseService().database;

    final result = await database.query(
      tableName,
      columns: ['numPledgedGifts'],
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return result.first['numPledgedGifts'] as int?;
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final database = await DatabaseService().database;
    return await database.query(tableName);
  }
}
