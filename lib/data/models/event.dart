import 'package:hedieaty2/data/models/gift.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Status {
  Upcoming,
  Current,
  Past;
}

enum Category { birthday, party, conference }

class Event {
  final String id;
  final String name;
  final Category category;
  final Status status;
  final DateTime date;
  final String location;
  final String description;
  final String userID;
  final List<Gift> giftList;

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
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
      'userID': userID,
    };
  }
}
