import 'package:hedieaty2/database/database_service.dart';
import 'package:sqflite/sqflite.dart';

class UsersDB {
  final tableName = 'users';

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS users (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        preferences TEXT NOT NULL
      );
    """);
  }

  Future<int> create({required String name, required String email, required String preferences}) async {
  final database = await DatabaseService().database;
  
  // Perform the raw insert into the 'users' table
  return await database.rawInsert("""
    INSERT INTO users (name, email, preferences)
    VALUES (?, ?, ?)
  """, [name, email, preferences]);
}
}
