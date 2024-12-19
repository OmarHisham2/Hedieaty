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
  final bool isPublished;
  String pledgerID;
  String id = uuid.v4();

  Gift(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.giftCategory,
      this.pledgerID = '',
      this.isPublished = false,
      this.giftStatus = GiftStatus.available});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
    };
  }

  factory Gift.fromMap(Map<dynamic, dynamic> map) {
    return Gift(
        id: '',
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        price: map['price']?.toDouble() ?? 0.0,
        imageUrl: map['imageUrl'] ?? '',
        giftCategory: mapGiftCategoryFromString(map['category']),
        pledgerID: map['pledgerID'] ?? '');
  }
}

GiftCategory mapGiftCategoryFromString(String categoryText) {
  switch (categoryText.toLowerCase()) {
    case 'electronics':
      return GiftCategory.electronics;
    case 'books':
      return GiftCategory.books;
    case 'na':
      return GiftCategory.na;
    case 'toys':
      return GiftCategory.toys;
    case 'perfumes':
      return GiftCategory.perfumes;
    default:
      throw ArgumentError('Invalid gift category: $categoryText');
  }
}
