import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/repositories/events_db.dart';

class AddEvent {
  final EventsDB eventsDB;

  AddEvent(this.eventsDB);

  Future<void> call({
    required String id,
    required String name,
    required DateTime date,
    required String location,
    required String description,
    required String userID,
    required Category category,
    required bool isPublished,
  }) async {
    await eventsDB.create(
        id: id,
        name: name,
        date: date.toIso8601String(),
        location: location,
        description: description,
        userID: userID,
        category: category.name,
        isPublished: isPublished);
  }
}
