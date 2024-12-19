import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    super.key,
    required Widget title,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return Row(
                children: [
                  title,
                  addHorizontalSpace(20),
                  ToggleSwitch(
                    customWidths: const [90.0, 50.0],
                    cornerRadius: 20.0,
                    activeBgColors: const [
                      [Colors.green],
                      [Colors.redAccent]
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: const ['YES', 'NO'],
                    icons: const [
                      FontAwesomeIcons.check,
                      FontAwesomeIcons.times
                    ],
                    initialLabelIndex: state.value == true ? 0 : 1,
                    onToggle: (index) {
                      state.didChange(index == 0);
                    },
                  ),
                ],
              );
            });
}
