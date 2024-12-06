import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty2/data/repositories/friends_db.dart';
import 'package:hedieaty2/presentation/screens/home/add_friend.dart';
import 'package:hedieaty2/presentation/widgets/icon_next_to_title.dart';
import 'package:hedieaty2/presentation/widgets/add_event_button.dart';
import 'package:hedieaty2/presentation/widgets/my_event_button.dart';
import 'package:hedieaty2/services/auth/auth.dart';
import 'package:hedieaty2/core/constants/theme_manager.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _loggedinUserID = Auth().currentUser!.uid;

  final friendList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    ThemeManager themeManager = ThemeManager();

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
          mainAxisAlignment: MainAxisAlignment.start,
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
                        '5',
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
                            NavigateToScreen('myevents');
                          },
                          text: 'My Events',
                          subText: '3',
                        ),
                        addHorizontalSpace(10),
                        const AddEventButton(
                          text: 'Create \nYour Own \nEvent/List',
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
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: FriendsDB().getFriends(_loggedinUserID).asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                            ),
                            SizedBox(
                              width: 200,
                              child: const Divider(
                                color: Colors.grey,
                              ),
                            ),
                            addVerticalSpace(5),
                            Container(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    useSafeArea: true,
                                    builder: (context) => const AddFriend(),
                                  );
                                },
                                label: const Text(
                                  'Add Now',
                                ),
                                icon: const Icon(Icons.add),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    List<Map<String, dynamic>> friends = snapshot.data!;
                    return ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        var friend = friends[index];
                        return ListTile(
                          title: Text(friend['name']),
                          subtitle: Text(friend['status']),
                        );
                      },
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
