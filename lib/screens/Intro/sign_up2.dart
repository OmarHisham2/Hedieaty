import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';
import 'package:image_picker/image_picker.dart';

class SignUpProfile extends StatefulWidget {
  const SignUpProfile({super.key});

  @override
  State<SignUpProfile> createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile> {
  Uint8List? _image;

  void _selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Set a profile Picture',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            addVerticalSpace(40),
            Container(
              child: Stack(children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),
                Positioned(
                  bottom: 0,
                  left: 80,
                  child: IconButton(
                    onPressed: _selectImage,
                    icon: Icon(Icons.image),
                  ),
                )
              ]),
            ),
            addVerticalSpace(50),
            ElevatedButton(
              onPressed: () {},
              child: Text('Continue'),
            ),
            addVerticalSpace(20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Skip'),
            )
          ],
        ),
      ),
    );
  }
}
