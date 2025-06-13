import 'package:scouts_finances_client/scouts_finances_client.dart';

extension ParentExtension on Parent {
  String get fullName => '$firstName $lastName';
}

extension ChildExtension on Child {
  String get fullName => '$firstName $lastName';
}
