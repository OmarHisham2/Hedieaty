import 'package:flutter/material.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
          Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
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
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_android_sharp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      label: const Text('Phone Number'),
                    ),
                    obscureText: true,
                  ),
                  addVerticalSpace(20),
                  Center(
                      child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Register'),
                  ))
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Have an account?',
                style: Theme.of(context).textTheme.labelSmall!,
              ),
              addHorizontalSpace(5),
              Text(
                'Login Now!',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
