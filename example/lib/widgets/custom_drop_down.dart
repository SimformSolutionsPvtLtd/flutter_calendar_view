import 'package:flutter/material.dart';

import '../constants.dart';

class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown({
    Key? key,
    required this.length,
    required this.builder,
    required this.valueBuilder,
    this.onValueChanged,
    required this.initialValue,
    required this.label,
  }) : super(key: key);

  final int length;
  final Widget Function(BuildContext, int, T) builder;
  final T Function(int) valueBuilder;
  final void Function(T)? onValueChanged;
  final T initialValue;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: initialValue,
      focusColor: Colors.transparent,
      decoration: AppConstants.inputDecoration.copyWith(
        labelText: label,
      ),
      items: List.generate(
        length,
        (index) {
          final value = valueBuilder(index);
          return DropdownMenuItem<T>(
            value: value,
            child: builder(context, index, value),
            onTap: () {
              print("On item tap $value.");
            },
          );
        },
      ),
      onTap: () {
        print("On Tapped...");
      },
      onChanged: (value) {
        if (value == null) return;
        onValueChanged?.call(value);
      },
    );
  }
}
