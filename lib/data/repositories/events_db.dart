import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/models/gift.dart';
import 'package:hedieaty2/data/repositories/database_service.dart';
import 'package:sqflite/sqflite.dart';

class EventsDB {
  final tableName = 'events';

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS events (
        ID TEXT NOT NULL,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT NOT NULL,
        description TEXT NOT NULL,
        userID INTEGER NOT NULL,
        isPublished INTEGER NOT NULL DEFAULT 0, 
        FOREIGN KEY (userID) REFERENCES users(ID) ON DELETE CASCADE
      );
    """);
  }

  Future<int> create({
    required String id,
    required String name,
    required String date,
    required String location,
    required String description,
    required String userID,
    bool isPublished = false, 
  }) async {
    final database = await DatabaseService().database;

    return await database.rawInsert("""
      INSERT INTO events (id,name, date, location, description, userID, isPublished)
      VALUES (?,?, ?, ?, ?, ?, ?)
    """, [id, name, date, location, description, userID, isPublished ? 1 : 0]);
  }

  Future<List<Event>> getEventsByUserID(String userID) async {
    final database = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await database.query(
      tableName,
      where: 'userID = ?',
      whereArgs: [userID],
    );

    return results.map((row) {
      final date = DateTime.parse(row['date'] as String);

      return Event(
        id: row['ID'].toString(),
        name: row['name'] as String,
        category:
            Category.birthday, 
        status: _determineStatus(date),
        date: date,
        location: row['location'] as String,
        description: row['description'] as String,
        userID: row['userID'] as String,
        giftList: [], 
        isPublished: (row['isPublished'] as int) == 1, 
      );
    }).toList();
  }

  Future<bool> isEventPublished(String eventID) async {
    final database = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await database.query(
      tableName,
      columns: ['isPublished'],
      where: 'ID = ?',
      whereArgs: [eventID],
    );

    if (results.isEmpty) {
      
      return false;
    }

    
    return (results.first['isPublished'] as int) == 1;
  }

  Status _determineStatus(DateTime date) {
    final now = DateTime.now();
    if (date.isBefore(now)) {
      return Status.Past;
    } else if (date.isAfter(
      now.add(
        const Duration(days: 1),
      ),
    )) {
      return Status.Upcoming;
    } else {
      return Status.Current;
    }
  }
}
