import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/repositories/events_db.dart';
import 'package:hedieaty2/presentation/screens/extras/edit_event.dart';
import 'package:hedieaty2/presentation/widgets/event_item.dart';
import 'package:hedieaty2/presentation/widgets/event_item_managed.dart';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ManageEventsScreen extends StatefulWidget {
  final String userId;

  const ManageEventsScreen({super.key, required this.userId});

  @override
  State<ManageEventsScreen> createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  final EventsDB _eventsDB = EventsDB();
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() {
    setState(() {
      _eventsFuture = _eventsDB.getEventsByUserID(widget.userId);
    });
  }

  void editEventCallback(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builder) => EditEventScreen(event: event),
      ),
    );
  }

  void deleteEventCallback(String eventId, bool isPublished) {
    _deleteEvent(eventId, isPublished);
  }

  void _deleteEvent(String eventId, bool isPublished) async {
    if (isPublished && !(await InternetConnection().hasInternetAccess)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            content: AwesomeSnackbarContent(
              title: 'Cannot Delete Event',
              message: 'You have to be online to delete a published event.',
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              messageTextStyle: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
              contentType: ContentType.warning,
            ),
          ),
        );
      return;
    }

    try {
      if (isPublished) {
        final DatabaseReference ref =
            FirebaseDatabase.instance.ref("events/$eventId");
        final DataSnapshot snapshot = await ref.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          final userId = data['userID'];

          if (userId == widget.userId) {
            await ref.remove();
          } else {
            throw Exception("Unauthorized to delete this event.");
          }
        } else {
          throw Exception("Event not found in Realtime Database.");
        }
      }

      await _eventsDB.deleteEvent(eventId);
      _fetchEvents();

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            showCloseIcon: false,
            behavior: SnackBarBehavior.floating,
            content: AwesomeSnackbarContent(
              title: 'Event Deleted!',
              message: 'The event has been deleted successfully.',
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              messageTextStyle: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
              contentType: ContentType.success,
            ),
          ),
        );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete event: $e")),
      );
    }
  }

  Future<void> _confirmDelete(String eventId, bool isPublished) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Event"),
        content: const Text("Are you sure you want to delete this event?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _deleteEvent(eventId, isPublished);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Manage Events",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No events found."));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return EventItemManaged(
                  event: event,
                  onDelete: () =>
                      deleteEventCallback(event.id, event.isPublished),
                  onEdit: () async => {
                        if (event.isPublished ||
                            await InternetConnection().hasInternetAccess)
                          {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (builder) => EditEventScreen(
                                      event: event,
                                    ),
                                  ),
                                )
                                .then((value) => _fetchEvents())
                          }
                        else
                          {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  showCloseIcon: false,
                                  behavior: SnackBarBehavior.floating,
                                  content: AwesomeSnackbarContent(
                                    titleTextStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                    messageTextStyle: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                    title:
                                        'Cannot Edit Published Event While Offline!',
                                    message:
                                        'You have to be online to edit a published event.',
                                    contentType: ContentType.warning,
                                  ),
                                ),
                              )
                          }
                      });
            },
          );
        },
      ),
    );
  }
}
