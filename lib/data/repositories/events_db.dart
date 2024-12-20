import 'package:hedieaty2/data/models/event.dart';
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
        category TEXT NOT NULL,
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
    required String category,
    bool isPublished = false,
  }) async {
    final database = await DatabaseService().database;

    return await database.rawInsert("""
      INSERT INTO events (id,name, date, location, description, userID,category, isPublished)
      VALUES (?,?, ?, ?, ?, ?,?, ?)
    """, [
      id,
      name,
      date,
      location,
      description,
      userID,
      category,
      isPublished ? 1 : 0
    ]);
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
        category: _parseCategory(row['category'] as String),
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

  Category _parseCategory(String categoryString) {
    return Category.values.firstWhere(
      (category) => category.toString().split('.').last == categoryString,
      orElse: () => Category.party,
    );
  }

  Future<int> getCreatedEventsCount(String userId) async {
    final db = await DatabaseService().database;
    final result = await db
        .rawQuery('SELECT COUNT(*) FROM events WHERE userID = ?', [userId]);
    return Sqflite.firstIntValue(result) ?? 0;
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
    DateTime today = DateTime.now();
    DateTime todayDate = DateTime(today.year, today.month, today.day);
    DateTime eventDate = date;

    if (eventDate.isBefore(todayDate)) {
      return Status.Past;
    } else if (eventDate.year == today.year &&
        eventDate.month == today.month &&
        eventDate.day == today.day) {
      return Status.Current;
    } else {
      return Status.Upcoming;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final database = await DatabaseService().database;

    await database.delete(
      tableName,
      where: 'ID = ?',
      whereArgs: [eventId],
    );
  }

  Future<int> updateEvent(
      {required String id,
      required String name,
      required String description,
      required String location,
      required Category category,
      required DateTime date}) async {
    final database = await DatabaseService().database;

    return await database.update(
      tableName,
      {
        'name': name,
        'description': description,
        'location': location,
        'category': category.name,
        'date': date.toIso8601String(),
      },
      where: 'ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleIsPublished(String eventID) async {
    final database = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await database.query(
      tableName,
      columns: ['isPublished'],
      where: 'ID = ?',
      whereArgs: [eventID],
    );

    if (results.isEmpty) {
      throw Exception("Event with ID $eventID not found.");
    }

    final currentIsPublished = results.first['isPublished'] as int;

    final newIsPublished = currentIsPublished == 1 ? 0 : 1;

    await database.update(
      tableName,
      {'isPublished': newIsPublished},
      where: 'ID = ?',
      whereArgs: [eventID],
    );
  }
}
