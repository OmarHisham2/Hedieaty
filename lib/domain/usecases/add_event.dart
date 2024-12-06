import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/repositories/events_db.dart';

class AddEvent {
  final EventsDB eventsDB;

  AddEvent(this.eventsDB);

  Future<void> call({
    required String name,
    required DateTime date,
    required String location,
    required String description,
    required String userID,
    required Category category,
  }) async {
    await eventsDB.create(
      name: name,
      date: date.toIso8601String(),
      location: location,
      description: description,
      userID: userID,
    );
  }
}
