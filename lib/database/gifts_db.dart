import 'package:hedieaty2/database/database_service.dart';
import 'package:sqflite/sqflite.dart';

class GiftsDB {
  final tableName = 'gifts';

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS gifts (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        status TEXT NOT NULL,
        eventID INTEGER NOT NULL,
        image TEXT,
        FOREIGN KEY (eventID) REFERENCES events(ID) ON DELETE CASCADE
      );
    """);
  }

  Future<int> create({
    required String name,
    required String description,
    required String category,
    required double price,
    required String status,
    required int eventID,
    String? image, // Nullable image parameter
  }) async {
    final database = await DatabaseService().database;

    // Perform the raw insert into the 'gifts' table
    return await database.rawInsert("""
      INSERT INTO gifts (name, description, category, price, status, eventID, image)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    """, [name, description, category, price, status, eventID, image]);
  }

  Future<List<Map<String, dynamic>>> getGiftsByEvent(int eventID) async {
    final database = await DatabaseService().database;
    return await database
        .query(tableName, where: 'eventID = ?', whereArgs: [eventID]);
  }
}
