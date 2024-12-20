import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/models/gift.dart';
import 'package:hedieaty2/data/repositories/firebase_service.dart';
import 'package:hedieaty2/data/repositories/users_db.dart';
import 'package:hedieaty2/presentation/widgets/eventDataCard.dart';
import 'package:hedieaty2/presentation/widgets/frosted_eventData.dart';
import 'package:hedieaty2/presentation/widgets/gift_item_normal.dart';
import 'package:hedieaty2/services/auth/auth.dart';
import 'package:hedieaty2/services/notifications/notification_service.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';

enum GiftFilter { all, pledged, unpledged }

class EventScreenNormal extends StatefulWidget {
  const EventScreenNormal({super.key, required this.eventDetails});

  final Event eventDetails;

  @override
  State<EventScreenNormal> createState() => _EventScreenNormalState();
}

class _EventScreenNormalState extends State<EventScreenNormal> {
  final _rlService = FirebaseService();

  int pledgedGiftsCount = 0;
  int participantCount = 0;
  int totalGiftsCount = 0;
  String lastUpdatedTime = '';
  final String _eventCreatorID = '';

  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  GiftFilter selectedFilter = GiftFilter.all;

  @override
  void initState() {
    super.initState();
    _fetchPledgedAndParticipantCounts();
  }

  Future<void> _fetchPledgedAndParticipantCounts() async {
    final giftsRef = _database.child('events/${widget.eventDetails.id}/gifts');
    final snapshot = await giftsRef.get();

    if (snapshot.exists) {
      final giftsData = snapshot.value as Map<dynamic, dynamic>;
      final Set<String> uniquePledgerIDs = {};

      int pledged = 0;

      giftsData.forEach((key, gift) {
        final String pledgerID = gift['pledgerID'] ?? '';

        if (pledgerID.isNotEmpty) {
          pledged += 1;
          uniquePledgerIDs.add(pledgerID);
        }
      });

      setState(() {
        pledgedGiftsCount = pledged;
        participantCount = uniquePledgerIDs.length;
        totalGiftsCount = giftsData.length;
      });
    }
  }

  Future<String?> getEventOwnerID(String eventID) async {
    try {
      final eventRef = FirebaseDatabase.instance.ref('events/$eventID');
      final snapshot = await eventRef.child('userID').get();

      if (snapshot.exists) {
        return snapshot.value as String?;
      } else {
        print('No userID found for event $eventID');
        return null;
      }
    } catch (e) {
      print('Error fetching event owner ID: $e');
      return null;
    }
  }

  void onPledge(Gift giftDetails) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        final DatabaseReference giftRef = FirebaseDatabase.instance
            .ref('events/${widget.eventDetails.id}/gifts/${giftDetails.id}');

        await UsersDB().incrementPledgedGiftsCount(Auth().currentUser!.uid);

        await giftRef.update({
          'status': GiftStatus.pledged.name,
          'pledgerID': Auth().currentUser!.uid
        });

        final ownerID = await getEventOwnerID(widget.eventDetails.id);

        if (ownerID != null) {
          final recipientToken =
              await NotificationService().getTokenByID(ownerID);

          await NotificationService().sendPushNotification(
            recipientToken: recipientToken,
            title: 'Gift Pledged!',
            body:
                'A gift has been pledged in your event: ${widget.eventDetails.name}!',
          );
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              showCloseIcon: false,
              behavior: SnackBarBehavior.floating,
              content: AwesomeSnackbarContent(
                title: 'Gift Pledged!',
                message: 'You have successfully pledged this gift!',
                contentType: ContentType.success,
              ),
            ),
          );

        _fetchPledgedAndParticipantCounts();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pledge gift: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            showCloseIcon: false,
            behavior: SnackBarBehavior.floating,
            content: AwesomeSnackbarContent(
              title: 'Failed To Pledge Gift!',
              message: 'You have to be online to pledge a gift.!',
              contentType: ContentType.warning,
            ),
          ),
        );
    }
  }

  Widget buildFilterDropdown() {
    return DropdownButton<GiftFilter>(
      value: selectedFilter,
      onChanged: (GiftFilter? newFilter) {
        if (newFilter != null) {
          setState(() {
            selectedFilter = newFilter;
          });
        }
      },
      items: GiftFilter.values.map((GiftFilter filter) {
        return DropdownMenuItem<GiftFilter>(
          value: filter,
          child: Text(filter.toString().split('.').last.toUpperCase()),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.eventDetails.name,
          style: const TextStyle(fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FrostedGlassBox(
                  theChild: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.eventDetails.name,
                              style: textTheme.titleMedium!.copyWith(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        addVerticalSpace(7),
                        Row(
                          children: [
                            SizedBox(
                              width: 250,
                              child: Text(
                                  maxLines: 5,
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  widget.eventDetails.description),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Event Status: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(widget.eventDetails.status.name),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Text(
                                  'Location: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(widget.eventDetails.location),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  theWidth: double.infinity,
                  theHeight: 200,
                ),
              ),
              addVerticalSpace(15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      'Filter Gifts:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    buildFilterDropdown(),
                  ],
                ),
              ),
              StreamBuilder<DatabaseEvent>(
                stream: _database
                    .child('events/${widget.eventDetails.id}/gifts')
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return Column(children: [
                      Row(
                        children: [
                          Expanded(
                            child: EventDataCard(
                              title: 'Total Participants',
                              number: '$participantCount',
                              lastUpdated: lastUpdatedTime,
                              icon: Icons.person,
                            ),
                          ),
                          Expanded(
                            child: EventDataCard(
                              title: 'Gifts Pledged',
                              number: '$pledgedGiftsCount / $totalGiftsCount',
                              lastUpdated: lastUpdatedTime,
                              icon: Icons.present_to_all,
                            ),
                          ),
                        ],
                      ),
                      addVerticalSpace(15),
                      Container(
                        margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              'Gift List',
                              style:
                                  textTheme.titleLarge!.copyWith(fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  } else {
                    final giftsData =
                        snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                    final List<Gift> gifts = giftsData.entries.map((entry) {
                      final gift = Gift.fromMap(entry.value);
                      gift.id = entry.key;
                      return gift;
                    }).toList();

                    List<Gift> filteredGifts;
                    switch (selectedFilter) {
                      case GiftFilter.pledged:
                        filteredGifts = gifts
                            .where((gift) => gift.pledgerID.isNotEmpty)
                            .toList();
                        break;
                      case GiftFilter.unpledged:
                        filteredGifts = gifts
                            .where((gift) => gift.pledgerID.isEmpty)
                            .toList();
                        break;
                      case GiftFilter.all:
                      default:
                        filteredGifts = gifts;
                        break;
                    }

                    totalGiftsCount = gifts.length;
                    pledgedGiftsCount = filteredGifts
                        .where((gift) => gift.pledgerID.isNotEmpty)
                        .length;
                    lastUpdatedTime =
                        DateFormat('hh:mm a').format(DateTime.now());

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: EventDataCard(
                                title: 'Total Participants',
                                number: '$participantCount',
                                lastUpdated: lastUpdatedTime,
                                icon: Icons.person,
                              ),
                            ),
                            Expanded(
                              child: EventDataCard(
                                title: 'Gifts Pledged',
                                number: '$pledgedGiftsCount / $totalGiftsCount',
                                lastUpdated: lastUpdatedTime,
                                icon: Icons.present_to_all,
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Text(
                                'Gift List',
                                style: textTheme.titleLarge!
                                    .copyWith(fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(10),
                        filteredGifts.isEmpty
                            ? const Center(
                                child: Text('No Gifts Added yet!'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredGifts.length,
                                itemBuilder: (context, index) {
                                  final gift = filteredGifts[index];
                                  return Column(
                                    children: [
                                      GiftItemNormal(
                                        giftDetails: gift,
                                        isPledged: gift.pledgerID.isNotEmpty,
                                        onPledge: () {
                                          onPledge(gift);
                                        },
                                      ),
                                      addVerticalSpace(20),
                                    ],
                                  );
                                },
                              )
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
