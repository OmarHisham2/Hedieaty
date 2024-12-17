import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum GiftStatus { available, pledged, purchased }

enum GiftCategory { electronics, books, na, toys, perfumes }

class Gift {
  final String name;
  final double price;
  final String description;
  final String? imageUrl;
  final GiftCategory giftCategory;
  final GiftStatus giftStatus;
  final String id;

  Gift(
      {required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.giftCategory,
      this.giftStatus = GiftStatus.available})
      : id = uuid.v4();
}
