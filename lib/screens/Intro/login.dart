import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/firebase/auth.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  String? errorMessage = '';

  String _enteredMail = '';
  String _enteredPassword = '';

  Future<void> _signInWithEmailAndPassword() async {
    _formKey.currentState!.save();
    try {
      await Auth().signInWithEmailAndPassword(
          email: _enteredMail, password: _enteredPassword);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onSaved: (value) {
                      _enteredMail = value ?? '';
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
                    onSaved: (value) {
                      _enteredPassword = value ?? "";
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
                    onPressed: _signInWithEmailAndPassword,
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
              Text(
                'Register Now!',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          addVerticalSpace(90)
        ]),
      ),
    );
  }
}
