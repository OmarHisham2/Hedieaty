import 'package:flutter/material.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/data/repositories/friends_db.dart';
import 'package:hedieaty2/services/Users/UserService.dart';
import 'package:hedieaty2/services/notifications/notification_service.dart';

class AddFriend extends StatefulWidget {
  final String currentUserID;

  const AddFriend({super.key, required this.currentUserID});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final _formKey = GlobalKey<FormState>();
  String _enteredPhone = '';
  String? _errorMessage;

  final UserService _userService = UserService();

  Future<void> _addFriend() async {
    _formKey.currentState?.save();

    if (_enteredPhone.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a phone number.";
      });
      return;
    }

    try {
      final userMap = await _userService.fetchUserByPhone(_enteredPhone);

      if (userMap != null) {
        final friendID = userMap['id'];

        await FriendsDB().addFriend(
          userID: widget.currentUserID,
          friendID: friendID,
        );

        setState(() {
          _errorMessage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Friend added successfully!')),
        );
        NotificationService().sendPushNotification(
            recipientToken: await NotificationService().getTokenByID(friendID),
            title: 'Friend Notification',
            body: 'Someone has added you as a friend!');
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = "No user found with this phone number.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              addVerticalSpace(15),
              Text(
                'Add Friend',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 40),
              ),
              addVerticalSpace(25),
              Form(
                key: _formKey,
                child: TextFormField(
                  onSaved: (value) {
                    _enteredPhone = value ?? '';
                  },
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    prefixIconColor: Colors.black,
                    errorText: _errorMessage,
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              addVerticalSpace(25),
              ElevatedButton(
                onPressed: _addFriend,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
