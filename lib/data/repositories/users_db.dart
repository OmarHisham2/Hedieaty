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
        image TEXT
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
  }) async {
    final database = await DatabaseService().database;

    return await database.rawInsert("""
      INSERT INTO users (id,name, email, preferences,phone, image)
      VALUES (?,?, ?, ?,?, ?)
    """, [id, name, email, preferences, phone, image]);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final database = await DatabaseService().database;
    return await database.query(tableName);
  }
}
