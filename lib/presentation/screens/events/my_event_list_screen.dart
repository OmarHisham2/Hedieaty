import 'package:flutter/material.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/repositories/events_db.dart';
import 'package:hedieaty2/presentation/screens/events/event_screen.dart';
import 'package:hedieaty2/presentation/widgets/event_item.dart';
import 'package:hedieaty2/presentation/widgets/sort_options.dart';
import 'package:hedieaty2/presentation/screens/events/add_new_event.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/services/auth/auth.dart';

class MyEventList extends StatefulWidget {
  const MyEventList({super.key});

  @override
  State<MyEventList> createState() => _MyEventListState();
}

class _MyEventListState extends State<MyEventList> {
  late Future<List<Event>> _eventsFuture;

  void _fetchEvents() {
    setState(() {
      try {
        _eventsFuture = EventsDB().getEventsByUserID(Auth().currentUser!.uid);
      } catch (e) {
        print('Failed to get current user events.');
      }
    });
  }

  @override
  void initState() {
    _fetchEvents();
    super.initState();
  }

  void _navigateToAddEventScreen() async {
    
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const AddNewEvent()),
    );
    
    _fetchEvents();
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
                        'My Event List',
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
                          IconButton(
                            onPressed: _navigateToAddEventScreen,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
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
                      child: FutureBuilder<List<Event>>(
                        future: _eventsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No Events Found!'),
                            );
                          } else {
                            final events = snapshot.data!;
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  final event = events[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => EventScreen(
                                            eventDetails: event,
                                          ),
                                        ),
                                      );
                                    },
                                    child: EventItem(event: event),
                                  );
                                });
                          }
                        },
                      ),
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
