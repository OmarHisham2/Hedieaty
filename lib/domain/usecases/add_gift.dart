import 'package:hedieaty2/data/repositories/gifts_db.dart';

class AddGift {
  final GiftsDB giftsDB;

  AddGift(this.giftsDB);

  Future<void> call({
    required String id,
    required String name,
    required String description,
    required String category,
    required double price,
    required String status,
    required String eventID,
    String? image,
  }) async {
    await giftsDB.create(
      id: id,
      name: name,
      description: description,
      category: category,
      price: price,
      status: status,
      eventID: eventID,
      image: image,
    );
  }
}
