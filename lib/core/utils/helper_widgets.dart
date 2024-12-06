import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  } else {
    return null;
  }
}
