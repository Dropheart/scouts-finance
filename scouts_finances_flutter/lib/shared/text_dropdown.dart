import 'package:flutter/material.dart';

class TextDropdown<T, V> extends DropdownButton<V> {
  final List<T> values;
  final V? defaultValue;
  final V Function(T) valueToId;
  final String Function(T) valueToString;

  TextDropdown({
    super.key,
    required super.onChanged,
    required this.values,
    required this.valueToId,
    required this.valueToString,
    this.defaultValue,
  }) : super(
          value: defaultValue,
          items: values
              .map((value) => DropdownMenuItem<V>(
                  value: valueToId(value),
                  child: Text(valueToString(value)) // Customize as needed
                  ))
              .toList(),
        );
}
