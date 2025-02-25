import 'package:hedieaty2/data/repositories/database_service.dart';
import 'package:sqflite/sqflite.dart';

class FriendsDB {
  final tableName = 'friends';

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS friends (
        userID TEXT NOT NULL,
        friendID TEXT NOT NULL,
        PRIMARY KEY (userID, friendID),
        FOREIGN KEY (userID) REFERENCES users(ID) ON DELETE CASCADE,
        FOREIGN KEY (friendID) REFERENCES users(ID) ON DELETE CASCADE
      );
    """);
  }

  Future<int> addFriend({
    required String userID,
    required String friendID,
  }) async {
    final database = await DatabaseService().database;

    return await database.rawInsert("""
      INSERT INTO friends (userID, friendID)
      VALUES (?, ?)
    """, [userID, friendID]);
  }

  Future<List<String>> getFriends(String userID) async {
    final database = await DatabaseService().database;

    List<Map<String, dynamic>> result = await database.rawQuery("""
    SELECT friendID FROM friends
    WHERE userID = ?
  """, [userID]);

    List<String> friendIDs =
        result.map((friend) => friend['friendID'] as String).toList();

    return friendIDs;
  }

  Future<int> removeFriend({
    required int userID,
    required int friendID,
  }) async {
    final database = await DatabaseService().database;

    return await database.rawDelete("""
      DELETE FROM friends
      WHERE userID = ? AND friendID = ?
    """, [userID, friendID]);
  }
}
