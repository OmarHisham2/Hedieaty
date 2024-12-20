import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/models/gift.dart';
import 'package:hedieaty2/data/repositories/events_db.dart';
import 'package:hedieaty2/data/repositories/firebase_service.dart';
import 'package:hedieaty2/data/repositories/gifts_db.dart';
import 'package:hedieaty2/presentation/screens/gifts/add_new_gift.dart';
import 'package:hedieaty2/presentation/widgets/eventDataCard.dart';
import 'package:hedieaty2/presentation/widgets/frosted_eventData.dart';
import 'package:hedieaty2/presentation/widgets/gift_item_listing.dart';
import 'package:hedieaty2/presentation/widgets/myCircle.dart';
import 'package:hedieaty2/services/auth/auth.dart';
import 'package:holdable_button/holdable_button.dart';
import 'package:holdable_button/utils/utils.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class EventScreenOwner extends StatefulWidget {
  const EventScreenOwner({super.key, required this.eventDetails});

  final Event eventDetails;

  @override
  State<EventScreenOwner> createState() => _EventScreenOwnerState();
}

class _EventScreenOwnerState extends State<EventScreenOwner> {
  final _rlService = FirebaseService();

  late bool _isPublished;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late Future<List<Gift>> _giftList;

  int giftCount = 0;
  int pledgedCount = 0;
  int participantCount = 0;

  void _fetchEventGifts(String eventID) {
    setState(() {
      try {
        _giftList = GiftsDB().getGiftsByEventID(eventID);
        _giftList.then((gifts) {
          setState(() {
            giftCount = gifts.length;
          });
        });

        _fetchPledgedAndParticipantCounts(eventID);
      } catch (e) {
        print('Failed to get current user gifts.');
      }
    });
  }

  Future<void> _fetchPledgedAndParticipantCounts(String eventID) async {
    final giftsRef = _database.child('events/$eventID/gifts');
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
        pledgedCount = pledged;
        participantCount = uniquePledgerIDs.length;
      });
    }
  }

  @override
  void initState() {
    _fetchEventGifts(widget.eventDetails.id);

    _isPublished = widget.eventDetails.isPublished;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    bool userOnline = false;

    void publishEvent() {
      setState(() {
        EventsDB().toggleIsPublished(widget.eventDetails.id);

        _isPublished = true;
        _rlService.rlCreateEvent(Event(
          name: widget.eventDetails.name,
          date: widget.eventDetails.date,
          location: widget.eventDetails.location,
          description: widget.eventDetails.description,
          userID: Auth().currentUser!.uid,
          category: widget.eventDetails.category,
          id: widget.eventDetails.id,
          status: widget.eventDetails.status,
          giftList: [],
        ));
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              showCloseIcon: false,
              behavior: SnackBarBehavior.floating,
              content: AwesomeSnackbarContent(
                title: 'Event Published!',
                message: 'You have successfully published this event.',
                contentType: ContentType.success,
              ),
            ),
          );
      });
    }

    void publishGift(Gift giftDetails) async {
      if (await InternetConnection().hasInternetAccess == false) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              showCloseIcon: false,
              behavior: SnackBarBehavior.floating,
              content: AwesomeSnackbarContent(
                title: 'Cannot Publish Gift',
                message: 'You have to be online to publish a gift!',
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
      await GiftsDB().toggleIsPublished(giftDetails.id);
      _rlService.rlAddGiftToEvent(
          widget.eventDetails.id,
          Gift(
            id: giftDetails.id,
            name: giftDetails.name,
            description: giftDetails.description,
            price: giftDetails.price,
            imageUrl: giftDetails.imageUrl,
            giftCategory: giftDetails.giftCategory,
            giftStatus: giftDetails.giftStatus,
            isPublished: true,
          ));
      setState(() {
        _fetchEventGifts(widget.eventDetails.id);
      });
    }

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
                                  'Publish Status: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                addHorizontalSpace(5),
                                MyCircle(
                                    color: _isPublished
                                        ? Colors.green
                                        : Colors.red),
                                addHorizontalSpace(10),
                              ],
                            ),
                            const Spacer(),
                            _isPublished
                                ? const Text('')
                                : SizedBox(
                                    child: HoldableButton(
                                      loadingType: LoadingType.edgeLoading,
                                      buttonColor: Colors.transparent,
                                      loadingColor: isDark
                                          ? Colors.white
                                          : const Color(0xffe63c3a),
                                      duration: 4,
                                      radius: 25,
                                      onConfirm: publishEvent,
                                      strokeWidth: 5,
                                      width: 150,
                                      height: 50,
                                      child: OutlinedButton(
                                        child: const Text('Hold To Publish'),
                                        onPressed: () {},
                                      ),
                                    ),
                                  )
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
              Row(
                children: [
                  Expanded(
                    child: EventDataCard(
                      title: 'Total Participants',
                      number: participantCount.toString(),
                      lastUpdated: '22 Sep.2024',
                      icon: Icons.person,
                    ),
                  ),
                  Expanded(
                    child: EventDataCard(
                        title: 'Gifts Pledged',
                        number: '$pledgedCount / $giftCount',
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
                          onPressed: () async {
                            final isGiftAdded =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => AddNewGift(
                                  eventID: widget.eventDetails.id,
                                  isPublished: _isPublished,
                                ),
                              ),
                            );

                            if (isGiftAdded == true) {
                              setState(() {
                                _fetchEventGifts(widget.eventDetails.id);
                              });
                            }
                          },
                          icon: const Icon(Icons.add),
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
                              child: Text('No Gifts Added!'),
                            );
                          } else {
                            final gifts = snapshot.data!;
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: gifts.length,
                                itemBuilder: (context, index) {
                                  final gift = gifts[index];
                                  return Column(
                                    children: [
                                      GiftItemListed(
                                        giftDetails: gift,
                                        onPublish: _isPublished
                                            ? () {
                                                publishGift(gift);
                                              }
                                            : () {
                                                ScaffoldMessenger.of(context)
                                                  ..hideCurrentSnackBar()
                                                  ..showSnackBar(const SnackBar(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    showCloseIcon: false,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content:
                                                        AwesomeSnackbarContent(
                                                      title:
                                                          'Publish Your Event First!',
                                                      message:
                                                          'Your Event Must Be Published To Publish Your Gift.',
                                                      contentType:
                                                          ContentType.warning,
                                                    ),
                                                  ));
                                              },
                                        onDelete: () => setState(() async {
                                          if (widget.eventDetails.isPublished &&
                                              await InternetConnection()
                                                  .hasInternetAccess) {
                                            GiftsDB().deleteGiftByID(gift.id);
                                            GiftsDB().deleteGiftFromFB(
                                                widget.eventDetails.id,
                                                gift.id);

                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(SnackBar(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                showCloseIcon: false,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                content: AwesomeSnackbarContent(
                                                  title: 'Gift  Deleted!',
                                                  message:
                                                      'You have successfully deleted ${gift.name} from The Gift List.',
                                                  contentType:
                                                      ContentType.success,
                                                ),
                                              ));

                                            _fetchEventGifts(
                                                widget.eventDetails.id);
                                          } else if (widget
                                                  .eventDetails.isPublished &&
                                              await InternetConnection()
                                                      .hasInternetAccess ==
                                                  false) {
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(
                                                SnackBar(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  showCloseIcon: false,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content:
                                                      AwesomeSnackbarContent(
                                                    title: 'Cannot Delete Gift',
                                                    message:
                                                        'You have to be online to delete a gift from a published event.',
                                                    titleTextStyle: Theme.of(
                                                            context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    messageTextStyle: Theme.of(
                                                            context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                    contentType:
                                                        ContentType.warning,
                                                  ),
                                                ),
                                              );
                                          } else if (widget
                                                  .eventDetails.isPublished ==
                                              false) {
                                            GiftsDB().deleteGiftByID(gift.id);
                                          }
                                        }),
                                      ),
                                      addVerticalSpace(20)
                                    ],
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
