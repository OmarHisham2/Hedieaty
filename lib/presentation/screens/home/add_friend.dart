import 'package:flutter/material.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';

class AddFriend extends StatelessWidget {
  const AddFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
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
                child: TextFormField(
                  onSaved: (value) {},
                ),
              ),
              addVerticalSpace(25),
              ElevatedButton(onPressed: () {}, child: const Text('Add'))
            ],
          ),
        ),
      ),
    );
  }
}
