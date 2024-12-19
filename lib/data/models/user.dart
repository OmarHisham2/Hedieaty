import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/models/gift.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User {
  final String displayName;
  final String email;
  final String password;
  final List<Event> createdEvents;
  final List<Gift> pledgedGifts;
  final String id;
  int numPledgedGifts;

  User(
    this.email,
    this.password, {
    required this.displayName,
    this.numPledgedGifts = 0
  })  : id = uuid.v4(),
        createdEvents = [],
        pledgedGifts = [];
}
