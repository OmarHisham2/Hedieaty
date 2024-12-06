import 'package:hedieaty2/data/models/gift.dart';
import 'package:hedieaty2/data/repositories/database_service.dart';
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
    required String eventID,
    String? image, 
  }) async {
    final database = await DatabaseService().database;

    
    return await database.rawInsert("""
      INSERT INTO gifts (name, description, category, price, status, eventID, image)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    """, [name, description, category, price, status, eventID, image]);
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
        name: row['name'] as String,
        description: row['description'] as String,
        price: row['price'] as double,
        imageUrl: row['image'] as String?,
        giftCategory: GiftCategory.values.firstWhere(
          (category) =>
              category.toString() == 'GiftCategory.${row['category']}',
          orElse: () => GiftCategory.books,
        ),
      );
    }).toList();
  }
}
