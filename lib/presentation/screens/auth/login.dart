import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/presentation/screens/auth/sign_up.dart';
import 'package:hedieaty2/services/auth/auth.dart';
import 'package:hedieaty2/presentation/screens/home/home_screen.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  String? errorMessage = '';

  String _enteredMail = '';
  String _enteredPassword = '';
  final String _enteredDisplayName = '';

  @override
  Widget build(BuildContext context) {
    Future<void> signInWithEmailAndPassword() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          await Auth().signInWithEmailAndPassword(
              email: _enteredMail, password: _enteredPassword);

          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            errorMessage = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            errorMessage = 'Wrong password provided for that user.';
          } else if (e.code == 'invalid-email') {
            errorMessage = 'The email address is not valid.';
          } else if (e.code == 'invalid-credential') {
            errorMessage =
                'Incorrect E-Mail and Password Combination\nTry again.';
          }

          StylishDialog dialog = StylishDialog(
            context: context,
            alertType: StylishDialogType.ERROR,
            style: DefaultStyle(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xff151515)
                    : Colors.white),
            title: const Text('Incorrect Credentials'),
            content: Text(errorMessage!),
          );
          dialog.show();
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 75, 0, 0),
        child: Column(children: [
          Center(
            child: Hero(
              tag: 'appLogo',
              child: Image.asset(
                'assets/images/appLogo.png',
                width: 250,
                height: 250,
              ),
            ),
          ),
          Text(
            'Hedieaety',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          addVerticalSpace(5),
          const Text('An Event Management Application'),
          addVerticalSpace(30),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const ValueKey('email_field'),
                    onSaved: (value) {
                      _enteredMail = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
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
                      label: const Text('Email'),
                    ),
                  ),
                  addVerticalSpace(25),
                  TextFormField(
                    key: const ValueKey('password_field'),
                    onSaved: (value) {
                      _enteredPassword = value ?? "";
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
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
                  addVerticalSpace(35),
                  Center(
                      child: ElevatedButton(
                    key: const ValueKey('submit_button'),
                    onPressed: signInWithEmailAndPassword,
                    child: const Text('Log In'),
                  ))
                ],
              ),
            ),
          ),
          addVerticalSpace(5),
          const SizedBox(
            width: 150,
            child: Divider(),
          ),
          addVerticalSpace(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account?',
                style: Theme.of(context).textTheme.labelSmall!,
              ),
              addHorizontalSpace(5),
              InkWell(
                child: Text(
                  'Register Now!',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) => RegisterScreen(),
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }
}
