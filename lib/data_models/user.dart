import 'package:hedieaty2/data_models/event.dart';
import 'package:hedieaty2/data_models/gift.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User {
  final String name;
  final String phoneNumber;
  final List<Event> createdEvents;
  final List<Gift> pledgedGifts;
  final String id;

  User(
      {required this.name,
      required this.phoneNumber,
      required this.createdEvents,
      required this.pledgedGifts})
      : id = uuid.v4();
}
