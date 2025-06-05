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

abstract class Parent implements _i1.SerializableModel {
  Parent._({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.balance,
  });

  factory Parent({
    int? id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required int balance,
  }) = _ParentImpl;

  factory Parent.fromJson(Map<String, dynamic> jsonSerialization) {
    return Parent(
      id: jsonSerialization['id'] as int?,
      firstName: jsonSerialization['firstName'] as String,
      lastName: jsonSerialization['lastName'] as String,
      email: jsonSerialization['email'] as String,
      phone: jsonSerialization['phone'] as String,
      balance: jsonSerialization['balance'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String firstName;

  String lastName;

  String email;

  String phone;

  int balance;

  /// Returns a shallow copy of this [Parent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Parent copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    int? balance,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'balance': balance,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ParentImpl extends Parent {
  _ParentImpl({
    int? id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required int balance,
  }) : super._(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          balance: balance,
        );

  /// Returns a shallow copy of this [Parent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Parent copyWith({
    Object? id = _Undefined,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    int? balance,
  }) {
    return Parent(
      id: id is int? ? id : this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
    );
  }
}
