import 'package:hedieaty2/data_models/gift.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Status {
  Upcoming,
  Current,
  Past;
}

enum Category { birthday, party, conference }

class Event {
  final String name;
  final Category category;
  final Status status;
  final DateTime date;
  final List<Gift> giftList;

  Event(this.giftList, this.date,
      {required this.name, required this.category, required this.status});
}
