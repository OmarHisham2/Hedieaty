import 'package:hedieaty2/database/database_service.dart';
import 'package:sqflite/sqflite.dart';

class EventsDB {
  final tableName = 'events';

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS events (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT NOT NULL,
        description TEXT NOT NULL,
        userID INTEGER NOT NULL,
        FOREIGN KEY (userID) REFERENCES users(ID) ON DELETE CASCADE
      );
    """);
  }

  Future<int> create({
    required String name,
    required String date,
    required String location,
    required String description,
    required int userID,
  }) async {
    final database = await DatabaseService().database;

    // Perform the raw insert into the 'events' table
    return await database.rawInsert("""
      INSERT INTO events (name, date, location, description, userID)
      VALUES (?, ?, ?, ?, ?)
    """, [name, date, location, description, userID]);
  }
}