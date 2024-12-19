import 'package:hedieaty2/data/models/gift.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Status {
  Upcoming,
  Current,
  Past,
}

enum Category { birthday, party, conference }

class Event {
  String id;
  final String name;
  final Category category;
  final Status status;
  final DateTime date;
  final String location;
  final String description;
  final String userID;
  final List<Gift> giftList;
  final bool isPublished;

  Event({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.date,
    required this.location,
    required this.description,
    required this.userID,
    required this.giftList,
    this.isPublished = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
      'userID': userID,
      'giftList': giftList.map((gift) => gift.toMap()).toList(),
      'isPublished': isPublished ? 1 : 0,
    };
  }

  factory Event.fromMap(Map<dynamic, dynamic> map) {
    return Event(
      id: '',
      name: map['name'] ?? '',
      category: Category.birthday,
      status: Status.Current,
      date: DateTime.parse(map['date']),
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      userID: map['userID'] ?? '',
      giftList: _parseGifts(map['giftList'] ?? []),
      isPublished: map['isPublished'] == 1,
    );
  }

  static List<Gift> _parseGifts(List<dynamic> gifts) {
    return gifts
        .map((gift) => Gift.fromMap(gift as Map<String, dynamic>))
        .toList();
  }
}
