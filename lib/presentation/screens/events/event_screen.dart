import 'package:flutter/material.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/models/gift.dart';
import 'package:hedieaty2/data/repositories/gifts_db.dart';
import 'package:hedieaty2/presentation/screens/gifts/add_new_gift.dart';
import 'package:hedieaty2/presentation/widgets/eventDataCard.dart';
import 'package:hedieaty2/presentation/widgets/gift_item_listing.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key, required this.eventDetails});

  final Event eventDetails;

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late Future<List<Gift>> _giftList;

  void _fetchEventGifts(String eventID) {
    setState(() {
      try {
        _giftList = GiftsDB().getGiftsByEventID(eventID);
      } catch (e) {
        print('Failed to get current user events.');
      }
    });
  }

  @override
  void initState() {
    _fetchEventGifts(widget.eventDetails.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Color.fromARGB(255, 28, 32, 35)
                              : Color(0xffe63c3a),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(25, 0, 10, 0),
                          child: Text(
                            widget.eventDetails.name,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -5,
                        left: -20,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              isDark ? Color(0xff232d35) : Color(0xffe63c3a),
                          child: CircleAvatar(
                            radius: 23,
                            backgroundColor:
                                isDark ? Color(0xff161617) : Colors.red[400],
                            child: const Icon(
                              Icons.celebration,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              addVerticalSpace(25),
              Row(
                children: [
                  Expanded(
                    child: EventDataCard(
                      title: 'Total Participants',
                      number: '2',
                      lastUpdated: '22 Sep.2024',
                      icon: Icons.person,
                    ),
                  ),
                  Expanded(
                    child: EventDataCard(
                        title: 'Gifts Pledged',
                        number: '3 / ',
                        lastUpdated: '22 Sep.2024',
                        icon: Icons.present_to_all),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Gift List',
                          style: textTheme.titleLarge!.copyWith(fontSize: 25),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => AddNewGift(
                                    eventID: widget.eventDetails.id)));
                          },
                          icon: Icon(Icons.add),
                        )
                      ],
                    ),
                    addVerticalSpace(10),
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                      child: FutureBuilder<List<Gift>>(
                        future: _giftList,
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
                            final gifts = snapshot.data!;
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: gifts.length,
                                itemBuilder: (context, index) {
                                  final gift = gifts[index];
                                  return InkWell(
                                    onTap: () {},
                                    child: GiftItemListed(giftDetails: gift),
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
