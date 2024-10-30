import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty2/components/home_screen/sleek_card_button.dart';
import 'package:hedieaty2/components/home_screen/user_item.dart';
import 'package:hedieaty2/data_models/user.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
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
                  style: GoogleFonts.poppins(fontSize: 30, color: Colors.grey),
                ),
                Text(
                  'User!',
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
                const GoodCard(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 50, 0, 0),
            child: Text(
              'My Contacts',
              style: textTheme.titleLarge!.copyWith(fontSize: 25),
            ),
          ),
          addVerticalSpace(10),
          Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 10, 0),
            child: Column(
              children: [
                UserItem(
                  userData: User(
                      name: 'Omar',
                      createdEvents: [],
                      pledgedGifts: [],
                      phoneNumber: '01004111222'),
                ),
                UserItem(
                  userData: User(
                      name: 'Omar',
                      createdEvents: [],
                      pledgedGifts: [],
                      phoneNumber: '01000100311'),
                ),
                UserItem(
                  userData: User(
                      name: 'Omar',
                      createdEvents: [],
                      pledgedGifts: [],
                      phoneNumber: '0106147853'),
                ),
                UserItem(
                  userData: User(
                      name: 'Omar',
                      createdEvents: [],
                      pledgedGifts: [],
                      phoneNumber: '01004441517'),
                ),
                UserItem(
                  userData: User(
                      name: 'Omar',
                      createdEvents: [],
                      pledgedGifts: [],
                      phoneNumber: '01224448999'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
