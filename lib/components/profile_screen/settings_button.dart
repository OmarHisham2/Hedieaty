import 'package:flutter/material.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onpressed;

  const SettingsButton({
    required this.icon,
    required this.label,
    required this.onpressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => onpressed,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Row(
            children: [
              Icon(icon),
              addHorizontalSpace(20),
              Text(label),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios)
            ],
          ),
        ));
  }
}
