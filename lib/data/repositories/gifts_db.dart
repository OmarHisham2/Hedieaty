import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty2/data/models/gift.dart';
import 'package:hedieaty2/data/repositories/database_service.dart';
import 'package:sqflite/sqflite.dart';

class GiftsDB {
  final tableName = 'gifts';
  final DatabaseReference _giftsRef = FirebaseDatabase.instance.ref('events');

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS $tableName (
        id TEXT PRIMARY KEY NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        status TEXT NOT NULL,
        eventID TEXT NOT NULL,
        image TEXT,
        isPublished INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (eventID) REFERENCES events(ID) ON DELETE CASCADE
      );
    """);
  }

  Future<List<Map<String, dynamic>>> getPledgedGifts(String userID) async {
    List<Map<String, dynamic>> pledgedGifts = [];
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    try {
      final eventsSnapshot = await database.child('events').get();

      if (eventsSnapshot.exists) {
        final eventsData = eventsSnapshot.value as Map<dynamic, dynamic>;

        for (final eventID in eventsData.keys) {
          final event = eventsData[eventID];
          final eventName = event['name'];

          if (event.containsKey('gifts')) {
            final giftsData = event['gifts'] as Map<dynamic, dynamic>;

            giftsData.forEach((giftID, giftValue) {
              if (giftValue['pledgerID'] == userID) {
                pledgedGifts.add({
                  'gift': Gift.fromMap(giftValue),
                  'eventName': eventName,
                });
              }
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching pledged gifts: $e');
    }

    return pledgedGifts;
  }

  Future<int> create({
    required String id,
    required String name,
    required String description,
    required String category,
    required double price,
    required String status,
    required String eventID,
    String? image,
    bool isPublished = false,
  }) async {
    final database = await DatabaseService().database;

    return await database.rawInsert("""
      INSERT INTO $tableName (id, name, description, category, price, status, eventID, image, isPublished)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, [
      id,
      name,
      description,
      category,
      price,
      status,
      eventID,
      image,
      isPublished ? 1 : 0
    ]);
  }

  Future<bool> isGiftPublished(String giftID) async {
    final database = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await database.query(
      tableName,
      columns: ['isPublished'],
      where: 'id = ?',
      whereArgs: [giftID],
    );

    if (results.isEmpty) {
      return false;
    }

    return (results.first['isPublished'] as int) == 1;
  }

  Future<void> toggleIsPublished(String giftID) async {
    final database = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await database.query(
      tableName,
      columns: ['isPublished'],
      where: 'id = ?',
      whereArgs: [giftID],
    );

    if (results.isEmpty) {
      throw Exception("Gift with ID $giftID not found.");
    }

    final currentIsPublished = results.first['isPublished'] as int;

    const newIsPublished = 1;

    await database.update(
      tableName,
      {'isPublished': newIsPublished},
      where: 'id = ?',
      whereArgs: [giftID],
    );
  }

  Future<int> deleteGiftByID(String giftID) async {
    final database = await DatabaseService().database;

    return await database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [giftID],
    );
  }

  Future<List<Gift>> getGiftsByEventID(String eventID) async {
    final database = await DatabaseService().database;

    final List<Map<String, dynamic>> results = await database.query(
      tableName,
      where: 'eventID = ?',
      whereArgs: [eventID],
    );

    return results.map((row) {
      return Gift(
        id: row['id'] as String,
        name: row['name'] as String,
        description: row['description'] as String,
        price: row['price'] as double,
        imageUrl: row['image'] as String?,
        giftStatus: GiftStatus.values.firstWhere(
          (status) => status.toString() == 'GiftStatus.${row['status']}',
          orElse: () => GiftStatus.available,
        ),
        giftCategory: GiftCategory.values.firstWhere(
          (category) =>
              category.toString() == 'GiftCategory.${row['category']}',
          orElse: () => GiftCategory.books,
        ),
        isPublished: row['isPublished'] as int == 1,
      );
    }).toList();
  }

  Future<void> deleteGiftFromFB(String eventID, String giftID) async {
    try {
      final giftRef = _giftsRef.child('$eventID/gifts/$giftID');
      await giftRef.remove();
      print('Gift deleted successfully.');
    } catch (e) {
      print('Failed to delete gift: $e');
    }
  }

  Future<void> updateGiftStatus(String giftID, GiftStatus status) async {
    try {
      await _giftsRef
          .child('gifts')
          .child(giftID)
          .update({'giftStatus': status.name});
    } catch (e) {
      throw Exception('Error updating gift status: $e');
    }
  }
}
