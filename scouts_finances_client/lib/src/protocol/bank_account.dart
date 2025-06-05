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
import 'parent.dart' as _i2;

abstract class BankAccount implements _i1.SerializableModel {
  BankAccount._({
    this.id,
    required this.accountNumber,
    required this.sortCode,
    required this.name,
    this.parentId,
    this.parent,
  });

  factory BankAccount({
    int? id,
    required String accountNumber,
    required String sortCode,
    required String name,
    int? parentId,
    _i2.Parent? parent,
  }) = _BankAccountImpl;

  factory BankAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return BankAccount(
      id: jsonSerialization['id'] as int?,
      accountNumber: jsonSerialization['accountNumber'] as String,
      sortCode: jsonSerialization['sortCode'] as String,
      name: jsonSerialization['name'] as String,
      parentId: jsonSerialization['parentId'] as int?,
      parent: jsonSerialization['parent'] == null
          ? null
          : _i2.Parent.fromJson(
              (jsonSerialization['parent'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String accountNumber;

  String sortCode;

  String name;

  int? parentId;

  _i2.Parent? parent;

  /// Returns a shallow copy of this [BankAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BankAccount copyWith({
    int? id,
    String? accountNumber,
    String? sortCode,
    String? name,
    int? parentId,
    _i2.Parent? parent,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'accountNumber': accountNumber,
      'sortCode': sortCode,
      'name': name,
      if (parentId != null) 'parentId': parentId,
      if (parent != null) 'parent': parent?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BankAccountImpl extends BankAccount {
  _BankAccountImpl({
    int? id,
    required String accountNumber,
    required String sortCode,
    required String name,
    int? parentId,
    _i2.Parent? parent,
  }) : super._(
          id: id,
          accountNumber: accountNumber,
          sortCode: sortCode,
          name: name,
          parentId: parentId,
          parent: parent,
        );

  /// Returns a shallow copy of this [BankAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BankAccount copyWith({
    Object? id = _Undefined,
    String? accountNumber,
    String? sortCode,
    String? name,
    Object? parentId = _Undefined,
    Object? parent = _Undefined,
  }) {
    return BankAccount(
      id: id is int? ? id : this.id,
      accountNumber: accountNumber ?? this.accountNumber,
      sortCode: sortCode ?? this.sortCode,
      name: name ?? this.name,
      parentId: parentId is int? ? parentId : this.parentId,
      parent: parent is _i2.Parent? ? parent : this.parent?.copyWith(),
    );
  }
}
