import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data/repositories/users_db.dart';
import 'package:hedieaty2/services/auth/auth.dart';
import 'package:hedieaty2/presentation/screens/home/home_screen.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/services/notifications/notification_service.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  String? errorMessage = '';

  String _enteredName = '';
  String _enteredMail = '';
  String _enteredPassword = '';
  String _enteredPhone = '';

  @override
  Widget build(BuildContext context) {
    Future<void> createUserWithEmailAndPassword() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          await Auth().createUserWithEmailAndPassword(
            email: _enteredMail,
            password: _enteredPassword,
          );

          final user = Auth().currentUser;
          String userToken = '0';

          await user!.updateDisplayName(_enteredName);

          final DatabaseReference dbRef =
              FirebaseDatabase.instance.ref().child('users').child(user.uid);

          await NotificationService().getDeviceToken().then((value) {
            userToken = value;
          });

          await dbRef.set({
            'name': _enteredName,
            'email': _enteredMail,
            'phone': _enteredPhone,
            'preferences': '',
            'pledgedGifts': [],
            'events': [],
            'fcmtoken': userToken
          });

          await UsersDB().create(
            id: user.uid,
            name: _enteredName,
            email: _enteredMail,
            phone: _enteredPhone,
            preferences: '',
          );

          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            errorMessage = 'Weak password';
          } else if (e.code == 'email-already-in-use') {
            errorMessage = 'This E-Mail is already registered!';
          } else {
            errorMessage = 'An error occurred. Please try again.';
          }
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Registration Error'),
              content: Text(errorMessage!),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 75, 0, 0),
        child: Column(
          children: [
            Center(
              child: Hero(
                tag: 'appLogo',
                child: Image.asset(
                  'assets/images/appLogo.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Text(
              'Hedieaety',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            addVerticalSpace(5),
            const Text('An Event Management Application'),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (value) {
                        _enteredName = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        label: const Text('Display Name'),
                      ),
                    ),
                    addVerticalSpace(15),
                    TextFormField(
                      onSaved: (value) {
                        _enteredMail = value ?? "";
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        label: const Text('E-Mail'),
                      ),
                    ),
                    addVerticalSpace(15),
                    TextFormField(
                      onSaved: (value) {
                        _enteredPassword = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.password,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        label: const Text('Password'),
                      ),
                      obscureText: true,
                    ),
                    addVerticalSpace(15),
                    TextFormField(
                      onSaved: (value) {
                        _enteredPhone = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number cannot be empty';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        label: const Text('Phone Number'),
                      ),
                    ),
                    addVerticalSpace(35),
                    Center(
                      child: ElevatedButton(
                        onPressed: createUserWithEmailAndPassword,
                        child: const Text('Register'),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 150,
              child: Divider(
                color: Colors.grey,
              ),
            ),
            addVerticalSpace(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Have an account?',
                  style: Theme.of(context).textTheme.labelSmall!,
                ),
                addHorizontalSpace(5),
                GestureDetector(
                  child: Text(
                    'Login Now!',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
