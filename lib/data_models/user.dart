import 'package:hedieaty2/data_models/event.dart';
import 'package:hedieaty2/data_models/gift.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User {
  final String displayName;
  final String email;
  final String password;
  final String phoneNumber;
  final List<Event> createdEvents;
  final List<Gift> pledgedGifts;
  final String id;

  User(
    this.email,
    this.password, {
    required this.displayName,
    required this.phoneNumber,
  })  : id = uuid.v4(),
        createdEvents = [],
        pledgedGifts = [];
}
