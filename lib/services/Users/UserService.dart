import 'package:firebase_database/firebase_database.dart';

class UserService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  
  Future<Map<String, dynamic>?> fetchUserByPhone(String phone) async {
    try {
      
      final snapshot = await _database
          .child('users')
          .orderByChild('phone')
          .equalTo(phone)
          .limitToFirst(1)
          .get();

      if (snapshot.exists) {
        
        final userMap = snapshot.value as Map<dynamic, dynamic>;
        final userID = userMap.keys.first; 
        final userData = Map<String, dynamic>.from(userMap[userID]);
        userData['id'] = userID; 
        return userData;
      } else {
        print('No user found with the phone number: $phone');
        return null;
      }
    } catch (e) {
      print("Error fetching user by phone: $e");
      return null;
    }
  }

  
  Future<Map<String, dynamic>?> fetchUserById(String uid) async {
    try {
      
      DatabaseReference userRef = _database.child('users').child(uid);

      
      final snapshot = await userRef.get();

      if (snapshot.exists) {
        
        Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
        print("User Data: $userData");
        return userData;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }
}
