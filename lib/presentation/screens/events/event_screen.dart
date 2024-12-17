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

    bool userOnline =
        false; 

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.eventDetails.name,
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),

                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                  ),
                ),
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
                addVerticalSpace(20),
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
                          addHorizontalSpace(15.0),
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
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
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
      ),
    );
  }
}
