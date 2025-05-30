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

abstract class BankAccount implements _i1.SerializableModel {
  BankAccount._({
    this.id,
    required this.accountNumber,
    required this.sortCode,
  });

  factory BankAccount({
    int? id,
    required String accountNumber,
    required String sortCode,
  }) = _BankAccountImpl;

  factory BankAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return BankAccount(
      id: jsonSerialization['id'] as int?,
      accountNumber: jsonSerialization['accountNumber'] as String,
      sortCode: jsonSerialization['sortCode'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String accountNumber;

  String sortCode;

  /// Returns a shallow copy of this [BankAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BankAccount copyWith({
    int? id,
    String? accountNumber,
    String? sortCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'accountNumber': accountNumber,
      'sortCode': sortCode,
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
  }) : super._(
          id: id,
          accountNumber: accountNumber,
          sortCode: sortCode,
        );

  /// Returns a shallow copy of this [BankAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BankAccount copyWith({
    Object? id = _Undefined,
    String? accountNumber,
    String? sortCode,
  }) {
    return BankAccount(
      id: id is int? ? id : this.id,
      accountNumber: accountNumber ?? this.accountNumber,
      sortCode: sortCode ?? this.sortCode,
    );
  }
}
