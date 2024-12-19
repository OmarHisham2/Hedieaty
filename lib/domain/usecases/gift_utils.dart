import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty2/data/models/gift.dart';

class GiftUtils {
  static Future<String> getPledgeInfo(
      {required String eventID, required String giftID}) async {
    try {
      final DatabaseReference giftRef =
          FirebaseDatabase.instance.ref('events/$eventID/gifts/$giftID');

      final DataSnapshot snapshot = await giftRef.get();

      if (snapshot.exists) {
        final Map<dynamic, dynamic> giftData =
            snapshot.value as Map<dynamic, dynamic>;

        final giftStatus = giftData['status'] as String?;
        final pledgerID = giftData['pledgerID'] as String?;

        if (giftStatus == GiftStatus.pledged.name) {
          return pledgerID != null
              ? 'Pledged by: $pledgerID'
              : 'Pledged (Unknown pledger)';
        } else {
          return 'Not pledged';
        }
      } else {
        return 'Gift not found';
      }
    } catch (e) {
      return 'Error fetching pledge info: $e';
    }
  }
}
