import 'package:uuid/uuid.dart';

const uuid = Uuid();


enum Status {
  upcoming,
  current,
  past;
}

enum Category {
  birthday,
  party,
  conference
}
class Event {
  final String name;
  final Category category;
  final Status status;

  Event({required this.name, required this.category, required this.status});
}
