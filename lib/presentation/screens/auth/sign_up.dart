import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data/repositories/users_db.dart';
import 'package:hedieaty2/services/auth/auth.dart';
import 'package:hedieaty2/presentation/screens/home/home_screen.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  String? errorMessage = '';

  String _enteredName = '';
  String _enteredMail = '';
  String _enteredPassword = '';

  @override
  Widget build(BuildContext context) {
    Future<void> createUserWithEmailAndPassword() async {
      _formKey.currentState!.save();
      try {
        await Auth().createUserWithEmailAndPassword(
            email: _enteredMail, password: _enteredPassword);

        // Setting Display Name
        Auth().currentUser!.updateDisplayName(_enteredName);
        await UsersDB().create(
            id: Auth().currentUser!.uid,
            name: _enteredName,
            email: _enteredMail,
            preferences: '');

        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('Weak password');
        } else if (e.code == 'email-already-in-use') {
          print('Account already exists');
        }
      }
    }

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
                    onPressed: createUserWithEmailAndPassword,
                    child: const Text('Register'),
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
        ]),
      ),
    );
  }
}
