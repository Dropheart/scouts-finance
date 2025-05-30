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
import 'payment_method.dart' as _i2;
import 'bank_account.dart' as _i3;

abstract class Payment implements _i1.SerializableModel {
  Payment._({
    this.id,
    required this.amount,
    required this.date,
    required this.reference,
    required this.method,
    required this.payee,
    this.bankAccountId,
    this.bankAccount,
  });

  factory Payment({
    int? id,
    required double amount,
    required DateTime date,
    required String reference,
    required _i2.PaymentMethod method,
    required String payee,
    int? bankAccountId,
    _i3.BankAccount? bankAccount,
  }) = _PaymentImpl;

  factory Payment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Payment(
      id: jsonSerialization['id'] as int?,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      reference: jsonSerialization['reference'] as String,
      method:
          _i2.PaymentMethod.fromJson((jsonSerialization['method'] as String)),
      payee: jsonSerialization['payee'] as String,
      bankAccountId: jsonSerialization['bankAccountId'] as int?,
      bankAccount: jsonSerialization['bankAccount'] == null
          ? null
          : _i3.BankAccount.fromJson(
              (jsonSerialization['bankAccount'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  double amount;

  DateTime date;

  String reference;

  _i2.PaymentMethod method;

  String payee;

  int? bankAccountId;

  _i3.BankAccount? bankAccount;

  /// Returns a shallow copy of this [Payment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Payment copyWith({
    int? id,
    double? amount,
    DateTime? date,
    String? reference,
    _i2.PaymentMethod? method,
    String? payee,
    int? bankAccountId,
    _i3.BankAccount? bankAccount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'amount': amount,
      'date': date.toJson(),
      'reference': reference,
      'method': method.toJson(),
      'payee': payee,
      if (bankAccountId != null) 'bankAccountId': bankAccountId,
      if (bankAccount != null) 'bankAccount': bankAccount?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentImpl extends Payment {
  _PaymentImpl({
    int? id,
    required double amount,
    required DateTime date,
    required String reference,
    required _i2.PaymentMethod method,
    required String payee,
    int? bankAccountId,
    _i3.BankAccount? bankAccount,
  }) : super._(
          id: id,
          amount: amount,
          date: date,
          reference: reference,
          method: method,
          payee: payee,
          bankAccountId: bankAccountId,
          bankAccount: bankAccount,
        );

  /// Returns a shallow copy of this [Payment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Payment copyWith({
    Object? id = _Undefined,
    double? amount,
    DateTime? date,
    String? reference,
    _i2.PaymentMethod? method,
    String? payee,
    Object? bankAccountId = _Undefined,
    Object? bankAccount = _Undefined,
  }) {
    return Payment(
      id: id is int? ? id : this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      reference: reference ?? this.reference,
      method: method ?? this.method,
      payee: payee ?? this.payee,
      bankAccountId: bankAccountId is int? ? bankAccountId : this.bankAccountId,
      bankAccount: bankAccount is _i3.BankAccount?
          ? bankAccount
          : this.bankAccount?.copyWith(),
    );
  }
}
