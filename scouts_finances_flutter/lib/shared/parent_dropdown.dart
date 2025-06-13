import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/name.dart';

class ParentDropdown extends DropdownButton<int> {
  final List<Parent> parents;
  final int? defaultParentId;

  ParentDropdown({
    super.key,
    required super.onChanged,
    required this.parents,
    this.defaultParentId,
  }) : super(
          value: defaultParentId,
          items: parents
              .map((parent) => DropdownMenuItem<int>(
                    value: parent.id,
                    child: Text(parent.fullName),
                  ))
              .toList(),
        );
}
