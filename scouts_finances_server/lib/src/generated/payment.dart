/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'payment_method.dart' as _i2;
import 'bank_account.dart' as _i3;

abstract class Payment
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Payment._({
    this.id,
    required this.amount,
    required this.date,
    required this.reference,
    required this.method,
    this.bankAccountId,
    this.bankAccount,
  }) : _eventRegistrationsPaymentsEventRegistrationsId = null;

  factory Payment({
    int? id,
    required double amount,
    required DateTime date,
    required String reference,
    required _i2.PaymentMethod method,
    int? bankAccountId,
    _i3.BankAccount? bankAccount,
  }) = _PaymentImpl;

  factory Payment.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentImplicit._(
      id: jsonSerialization['id'] as int?,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      reference: jsonSerialization['reference'] as String,
      method:
          _i2.PaymentMethod.fromJson((jsonSerialization['method'] as String)),
      bankAccountId: jsonSerialization['bankAccountId'] as int?,
      bankAccount: jsonSerialization['bankAccount'] == null
          ? null
          : _i3.BankAccount.fromJson(
              (jsonSerialization['bankAccount'] as Map<String, dynamic>)),
      $_eventRegistrationsPaymentsEventRegistrationsId:
          jsonSerialization['_eventRegistrationsPaymentsEventRegistrationsId']
              as int?,
    );
  }

  static final t = PaymentTable();

  static const db = PaymentRepository._();

  @override
  int? id;

  double amount;

  DateTime date;

  String reference;

  _i2.PaymentMethod method;

  int? bankAccountId;

  _i3.BankAccount? bankAccount;

  final int? _eventRegistrationsPaymentsEventRegistrationsId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Payment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Payment copyWith({
    int? id,
    double? amount,
    DateTime? date,
    String? reference,
    _i2.PaymentMethod? method,
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
      if (bankAccountId != null) 'bankAccountId': bankAccountId,
      if (bankAccount != null) 'bankAccount': bankAccount?.toJson(),
      if (_eventRegistrationsPaymentsEventRegistrationsId != null)
        '_eventRegistrationsPaymentsEventRegistrationsId':
            _eventRegistrationsPaymentsEventRegistrationsId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'amount': amount,
      'date': date.toJson(),
      'reference': reference,
      'method': method.toJson(),
      if (bankAccountId != null) 'bankAccountId': bankAccountId,
      if (bankAccount != null) 'bankAccount': bankAccount?.toJsonForProtocol(),
    };
  }

  static PaymentInclude include({_i3.BankAccountInclude? bankAccount}) {
    return PaymentInclude._(bankAccount: bankAccount);
  }

  static PaymentIncludeList includeList({
    _i1.WhereExpressionBuilder<PaymentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentTable>? orderByList,
    PaymentInclude? include,
  }) {
    return PaymentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Payment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Payment.t),
      include: include,
    );
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
    int? bankAccountId,
    _i3.BankAccount? bankAccount,
  }) : super._(
          id: id,
          amount: amount,
          date: date,
          reference: reference,
          method: method,
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
    Object? bankAccountId = _Undefined,
    Object? bankAccount = _Undefined,
  }) {
    return PaymentImplicit._(
      id: id is int? ? id : this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      reference: reference ?? this.reference,
      method: method ?? this.method,
      bankAccountId: bankAccountId is int? ? bankAccountId : this.bankAccountId,
      bankAccount: bankAccount is _i3.BankAccount?
          ? bankAccount
          : this.bankAccount?.copyWith(),
      $_eventRegistrationsPaymentsEventRegistrationsId:
          this._eventRegistrationsPaymentsEventRegistrationsId,
    );
  }
}

class PaymentImplicit extends _PaymentImpl {
  PaymentImplicit._({
    int? id,
    required double amount,
    required DateTime date,
    required String reference,
    required _i2.PaymentMethod method,
    int? bankAccountId,
    _i3.BankAccount? bankAccount,
    int? $_eventRegistrationsPaymentsEventRegistrationsId,
  })  : _eventRegistrationsPaymentsEventRegistrationsId =
            $_eventRegistrationsPaymentsEventRegistrationsId,
        super(
          id: id,
          amount: amount,
          date: date,
          reference: reference,
          method: method,
          bankAccountId: bankAccountId,
          bankAccount: bankAccount,
        );

  factory PaymentImplicit(
    Payment payment, {
    int? $_eventRegistrationsPaymentsEventRegistrationsId,
  }) {
    return PaymentImplicit._(
      id: payment.id,
      amount: payment.amount,
      date: payment.date,
      reference: payment.reference,
      method: payment.method,
      bankAccountId: payment.bankAccountId,
      bankAccount: payment.bankAccount,
      $_eventRegistrationsPaymentsEventRegistrationsId:
          $_eventRegistrationsPaymentsEventRegistrationsId,
    );
  }

  @override
  final int? _eventRegistrationsPaymentsEventRegistrationsId;
}

class PaymentTable extends _i1.Table<int?> {
  PaymentTable({super.tableRelation}) : super(tableName: 'payments') {
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    reference = _i1.ColumnString(
      'reference',
      this,
    );
    method = _i1.ColumnEnum(
      'method',
      this,
      _i1.EnumSerialization.byName,
    );
    bankAccountId = _i1.ColumnInt(
      'bankAccountId',
      this,
    );
    $_eventRegistrationsPaymentsEventRegistrationsId = _i1.ColumnInt(
      '_eventRegistrationsPaymentsEventRegistrationsId',
      this,
    );
  }

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnString reference;

  late final _i1.ColumnEnum<_i2.PaymentMethod> method;

  late final _i1.ColumnInt bankAccountId;

  _i3.BankAccountTable? _bankAccount;

  late final _i1.ColumnInt $_eventRegistrationsPaymentsEventRegistrationsId;

  _i3.BankAccountTable get bankAccount {
    if (_bankAccount != null) return _bankAccount!;
    _bankAccount = _i1.createRelationTable(
      relationFieldName: 'bankAccount',
      field: Payment.t.bankAccountId,
      foreignField: _i3.BankAccount.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.BankAccountTable(tableRelation: foreignTableRelation),
    );
    return _bankAccount!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        amount,
        date,
        reference,
        method,
        bankAccountId,
        $_eventRegistrationsPaymentsEventRegistrationsId,
      ];

  @override
  List<_i1.Column> get managedColumns => [
        id,
        amount,
        date,
        reference,
        method,
        bankAccountId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'bankAccount') {
      return bankAccount;
    }
    return null;
  }
}

class PaymentInclude extends _i1.IncludeObject {
  PaymentInclude._({_i3.BankAccountInclude? bankAccount}) {
    _bankAccount = bankAccount;
  }

  _i3.BankAccountInclude? _bankAccount;

  @override
  Map<String, _i1.Include?> get includes => {'bankAccount': _bankAccount};

  @override
  _i1.Table<int?> get table => Payment.t;
}

class PaymentIncludeList extends _i1.IncludeList {
  PaymentIncludeList._({
    _i1.WhereExpressionBuilder<PaymentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Payment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Payment.t;
}

class PaymentRepository {
  const PaymentRepository._();

  final attachRow = const PaymentAttachRowRepository._();

  final detachRow = const PaymentDetachRowRepository._();

  /// Returns a list of [Payment]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Payment>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PaymentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaymentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentTable>? orderByList,
    _i1.Transaction? transaction,
    PaymentInclude? include,
  }) async {
    return session.db.find<Payment>(
      where: where?.call(Payment.t),
      orderBy: orderBy?.call(Payment.t),
      orderByList: orderByList?.call(Payment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Payment] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Payment?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PaymentTable>? where,
    int? offset,
    _i1.OrderByBuilder<PaymentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaymentTable>? orderByList,
    _i1.Transaction? transaction,
    PaymentInclude? include,
  }) async {
    return session.db.findFirstRow<Payment>(
      where: where?.call(Payment.t),
      orderBy: orderBy?.call(Payment.t),
      orderByList: orderByList?.call(Payment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Payment] by its [id] or null if no such row exists.
  Future<Payment?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    PaymentInclude? include,
  }) async {
    return session.db.findById<Payment>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Payment]s in the list and returns the inserted rows.
  ///
  /// The returned [Payment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Payment>> insert(
    _i1.Session session,
    List<Payment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Payment>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Payment] and returns the inserted row.
  ///
  /// The returned [Payment] will have its `id` field set.
  Future<Payment> insertRow(
    _i1.Session session,
    Payment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Payment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Payment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Payment>> update(
    _i1.Session session,
    List<Payment> rows, {
    _i1.ColumnSelections<PaymentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Payment>(
      rows,
      columns: columns?.call(Payment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Payment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Payment> updateRow(
    _i1.Session session,
    Payment row, {
    _i1.ColumnSelections<PaymentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Payment>(
      row,
      columns: columns?.call(Payment.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Payment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Payment>> delete(
    _i1.Session session,
    List<Payment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Payment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Payment].
  Future<Payment> deleteRow(
    _i1.Session session,
    Payment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Payment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Payment>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PaymentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Payment>(
      where: where(Payment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PaymentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Payment>(
      where: where?.call(Payment.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PaymentAttachRowRepository {
  const PaymentAttachRowRepository._();

  /// Creates a relation between the given [Payment] and [BankAccount]
  /// by setting the [Payment]'s foreign key `bankAccountId` to refer to the [BankAccount].
  Future<void> bankAccount(
    _i1.Session session,
    Payment payment,
    _i3.BankAccount bankAccount, {
    _i1.Transaction? transaction,
  }) async {
    if (payment.id == null) {
      throw ArgumentError.notNull('payment.id');
    }
    if (bankAccount.id == null) {
      throw ArgumentError.notNull('bankAccount.id');
    }

    var $payment = payment.copyWith(bankAccountId: bankAccount.id);
    await session.db.updateRow<Payment>(
      $payment,
      columns: [Payment.t.bankAccountId],
      transaction: transaction,
    );
  }
}

class PaymentDetachRowRepository {
  const PaymentDetachRowRepository._();

  /// Detaches the relation between this [Payment] and the [BankAccount] set in `bankAccount`
  /// by setting the [Payment]'s foreign key `bankAccountId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> bankAccount(
    _i1.Session session,
    Payment payment, {
    _i1.Transaction? transaction,
  }) async {
    if (payment.id == null) {
      throw ArgumentError.notNull('payment.id');
    }

    var $payment = payment.copyWith(bankAccountId: null);
    await session.db.updateRow<Payment>(
      $payment,
      columns: [Payment.t.bankAccountId],
      transaction: transaction,
    );
  }
}
