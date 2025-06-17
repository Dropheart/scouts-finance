/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

enum GroupColour implements _i1.SerializableModel {
  green,
  lightblue,
  darkblue,
  teal,
  black,
  red;

  static GroupColour fromJson(String name) {
    switch (name) {
      case 'green':
        return GroupColour.green;
      case 'lightblue':
        return GroupColour.lightblue;
      case 'darkblue':
        return GroupColour.darkblue;
      case 'teal':
        return GroupColour.teal;
      case 'black':
        return GroupColour.black;
      case 'red':
        return GroupColour.red;
      default:
        throw ArgumentError(
            'Value "$name" cannot be converted to "GroupColour"');
    }
  }

  @override
  String toJson() => name;
  @override
  String toString() => name;
}
