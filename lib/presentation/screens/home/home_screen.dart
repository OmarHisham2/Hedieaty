import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty2/data/repositories/events_db.dart';
import 'package:hedieaty2/data/repositories/friends_db.dart';
import 'package:hedieaty2/data/repositories/users_db.dart';
import 'package:hedieaty2/presentation/screens/events/add_new_event.dart';
import 'package:hedieaty2/presentation/screens/events/my_event_list_screen.dart';
import 'package:hedieaty2/presentation/screens/events/normal_event_list_screen.dart';
import 'package:hedieaty2/presentation/screens/home/add_friend.dart';
import 'package:hedieaty2/presentation/widgets/icon_next_to_title.dart';
import 'package:hedieaty2/presentation/widgets/add_event_button.dart';
import 'package:hedieaty2/presentation/widgets/my_event_button.dart';
import 'package:hedieaty2/presentation/widgets/user_item.dart';
import 'package:hedieaty2/services/auth/auth.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _loggedinUserID = Auth().currentUser!.uid;

  List<Map<String, dynamic>> friendList = [];

  final DatabaseReference _firebaseRef = FirebaseDatabase.instance.ref();

  int pledgedGiftsCount = 0;
  int createdEventsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadFriends();
    _fetchPledgedGiftsFromLocalDB();
    _fetchCreatedEventsCountFromLocalDB();
  }

  Future<void> _loadFriends() async {
    try {
      List<String> friendIDs = await FriendsDB().getFriends(_loggedinUserID);

      if (friendIDs.isNotEmpty) {
        List<Map<String, dynamic>> friendsDetails = [];

        for (var friendID in friendIDs) {
          DataSnapshot snapshot =
              await _firebaseRef.child('users/$friendID').get();

          if (snapshot.exists) {
            friendsDetails.add({
              'friendID': friendID,
              'name': snapshot.child('name').value,
              'phone': snapshot.child('phone').value,
              'id': friendID,
            });
          }
        }

        setState(() {
          friendList = friendsDetails;
        });
      }
    } catch (e) {
      print('Error loading friends: $e');
    }
  }

  Future<void> _fetchPledgedGiftsFromLocalDB() async {
    try {
      int? count = await UsersDB().getPledgedGiftsCount(_loggedinUserID);

      setState(() {
        pledgedGiftsCount = count ?? 0;
      });
    } catch (e) {
      print('Error fetching pledged gifts count: $e');
    }
  }

  Future<void> _fetchCreatedEventsCountFromLocalDB() async {
    try {
      int count = await EventsDB().getCreatedEventsCount(_loggedinUserID);

      setState(() {
        createdEventsCount = count;
      });
    } catch (e) {
      print('Error fetching created events count from local database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    void NavigateToScreen(String routeName) {
      Navigator.of(context).pushNamed('/$routeName');
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Hedieaty',
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
            icon: const Icon(
              Icons.person,
            ),
            style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(context).iconTheme.color),
          ),
          IconButton(
            onPressed: () {
              Auth().signOut();
              Navigator.pushReplacementNamed(context, '/welcome');
            },
            icon: const Icon(Icons.logout),
            style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(context).iconTheme.color),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Row(
                children: [
                  Text(
                    'Welcome, ',
                    style:
                        GoogleFonts.poppins(fontSize: 30, color: Colors.grey),
                  ),
                  Text(
                    Auth().currentUser!.displayName.toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 25, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$pledgedGiftsCount',
                        style: textTheme.titleLarge,
                      ),
                      addHorizontalSpace(10),
                      Text('Pledged Gifts', style: textTheme.titleMedium),
                    ],
                  ),
                  addVerticalSpace(20),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GoodCard(
                          onClick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => const MyEventList(),
                              ),
                            ).then((value) {
                              setState(() {
                                _fetchCreatedEventsCountFromLocalDB();
                                _fetchPledgedGiftsFromLocalDB();
                              });
                            });
                          },
                          text: 'My Events',
                          subText: '$createdEventsCount',
                        ),
                        addHorizontalSpace(10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => const AddNewEvent(),
                              ),
                            ).then((value) {
                              setState(() {
                                _fetchCreatedEventsCountFromLocalDB();
                                _fetchPledgedGiftsFromLocalDB();
                              });
                            });
                          },
                          child: const AddEventButton(
                            text: 'Create \nYour Own \nEvent',
                          ),
                        ),
                        addHorizontalSpace(20)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 50, 0, 0),
              child: Row(
                children: [
                  Text(
                    'My Contacts',
                    style: textTheme.titleLarge!.copyWith(fontSize: 25),
                  ),
                  const Spacer(),
                  IconNextToTitleButton(
                    isDark: isDark,
                    icon: Icons.search,
                  ),
                  addHorizontalSpace(10)
                ],
              ),
            ),
            addVerticalSpace(10),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 10, 0),
              child: friendList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'No Friends Found!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          const SizedBox(
                            width: 200,
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          addVerticalSpace(5),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: friendList.length,
                      itemBuilder: (context, index) {
                        var friend = friendList[index];
                        return InkWell(
                          child: UserItem(
                            name: friend['name'] ?? 'null',
                            phone: friend['phone'] ?? 'null',
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (builder) => NormalEventListScreen(
                                  userID: friend['id'],
                                  userDisplayName: friend['name'],
                                ),
                              ),
                            )
                                .then((value) {
                              setState(() {
                                _fetchCreatedEventsCountFromLocalDB();
                                _fetchPledgedGiftsFromLocalDB();
                              });
                            });
                          },
                        );
                      },
                    ),
            ),
            addVerticalSpace(10),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    useSafeArea: true,
                    builder: (context) =>
                        AddFriend(currentUserID: _loggedinUserID),
                  ).then((value) => _loadFriends());
                },
                label: const Text(
                  'Add Friend',
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
