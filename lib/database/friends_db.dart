import 'package:hedieaty2/database/database_service.dart';
import 'package:sqflite/sqflite.dart';

class FriendsDB {
  final tableName = 'friends';

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS friends (
        userID INTEGER NOT NULL,
        friendID INTEGER NOT NULL,
        PRIMARY KEY (userID, friendID),
        FOREIGN KEY (userID) REFERENCES users(ID) ON DELETE CASCADE,
        FOREIGN KEY (friendID) REFERENCES users(ID) ON DELETE CASCADE
      );
    """);
  }

  Future<int> addFriend({
    required int userID,
    required int friendID,
  }) async {
    final database = await DatabaseService().database;

    // Perform the raw insert into the 'friends' table
    return await database.rawInsert("""
      INSERT INTO friends (userID, friendID)
      VALUES (?, ?)
    """, [userID, friendID]);
  }

  Future<List<Map<String, dynamic>>> getFriends(int userID) async {
    final database = await DatabaseService().database;

    // Retrieve all friends for the given userID
    return await database.rawQuery("""
      SELECT * FROM friends
      WHERE userID = ?
    """, [userID]);
  }

  Future<int> removeFriend({
    required int userID,
    required int friendID,
  }) async {
    final database = await DatabaseService().database;

    // Delete the friend relationship from the 'friends' table
    return await database.rawDelete("""
      DELETE FROM friends
      WHERE userID = ? AND friendID = ?
    """, [userID, friendID]);
  }
}
