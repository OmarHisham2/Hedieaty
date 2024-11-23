import 'package:flutter/material.dart';
import 'package:hedieaty2/components/events_screen/event_item.dart';
import 'package:hedieaty2/components/general_components/sort_options.dart';
import 'package:hedieaty2/data_models/event.dart';
import 'package:hedieaty2/screens/add_new_event.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

class MyEventList extends StatelessWidget {
  const MyEventList({super.key});

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
                    Text('Total Events: 5', style: textTheme.labelSmall),
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
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (ctx) => AddNewEvent()),
                              );
                            },
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
