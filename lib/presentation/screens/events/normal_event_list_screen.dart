import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/repositories/events_db.dart';
import 'package:hedieaty2/presentation/screens/events/event_screen_normal.dart';
import 'package:hedieaty2/presentation/widgets/event_item.dart';
import 'package:hedieaty2/presentation/widgets/event_item_user.dart';
import 'package:hedieaty2/presentation/widgets/sort_options.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/services/auth/auth.dart';

class NormalEventListScreen extends StatefulWidget {
  const NormalEventListScreen(
      {super.key, required this.userID, required this.userDisplayName});
  final String userID;
  final String userDisplayName;

  @override
  State<NormalEventListScreen> createState() => _NormalEventListScreenState();
}

class _NormalEventListScreenState extends State<NormalEventListScreen> {
  final DatabaseReference _eventsRef = FirebaseDatabase.instance.ref('events');
  final List<Event> _events = [];

  @override
  void initState() {
    super.initState();

    _eventsRef
        .orderByChild('userID')
        .equalTo(widget.userID)
        .onChildAdded
        .listen((event) {
      final eventData = event.snapshot.value as Map<dynamic, dynamic>;
      Event newEvent = Event.fromMap(eventData);
      newEvent.id = event.snapshot.key!;
      setState(() {
        _events.add(newEvent);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Hedieaty',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Column(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        "assets/images/eventList.png",
                        width: 150,
                      ),
                    ),
                    addVerticalSpace(15),
                    FittedBox(
                      child: Text(
                        '${widget.userDisplayName[0].toUpperCase() + widget.userDisplayName.substring(1)}\'s Event List',
                        style: textTheme.labelMedium!.copyWith(fontSize: 40),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            'Events',
                            style: textTheme.titleLarge!.copyWith(fontSize: 25),
                          ),
                          addHorizontalSpace(10),
                          const Spacer(),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Row(
                        children: [
                          const SortOption(text: 'Name'),
                          addHorizontalSpace(15),
                          const SortOption(text: 'Category'),
                          addHorizontalSpace(15),
                          const SortOption(text: 'Status')
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                      child: _events.isEmpty
                          ? Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 0),
                                child: const Text(
                                  'User Has Not Published Any Events!',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _events.length,
                              itemBuilder: (context, index) {
                                final event = _events[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => EventScreenNormal(
                                          eventDetails: event,
                                        ),
                                      ),
                                    );
                                  },
                                  child: EventItemUser(event: event),
                                );
                              }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
