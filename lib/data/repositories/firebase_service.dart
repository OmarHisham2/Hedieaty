import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/models/gift.dart';

class FirebaseService {
  final _real = FirebaseDatabase.instance;

  rlCreateEvent(Event event) {
    try {
      _real.ref("events").child(event.id).set({
        "name": event.name,
        "location": event.location,
        "description": event.description,
        "date": event.date.toString(),
        "userID": event.userID
      });
    } catch (e) {
      print('FAILED TO CREATE EVENT');
      print(e);
    }
  }

  rlAddGiftToEvent(String eventID, Gift gift) {
    try {
      _real.ref("events/$eventID/gifts/${gift.id}").set({
        "id": gift.id,
        "name": gift.name,
        "description": gift.description,
        "price": gift.price,
        "imageUrl": gift.imageUrl,
        "category": gift.giftCategory.toString().split('.').last,
        "status": gift.giftStatus.toString().split('.').last,
      });
    } catch (e) {
      print('FAILED TO ADD GIFT TO EVENT');
      print(e);
    }
  }
}
