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
import 'parent.dart' as _i4;

abstract class Payment
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Payment._({
    this.id,
    required this.amount,
    required this.date,
    required this.reference,
    required this.method,
    required this.payee,
    this.bankAccountId,
    this.bankAccount,
    this.parentId,
    this.parent,
  });

  factory Payment({
    int? id,
    required int amount,
    required DateTime date,
    required String reference,
    required _i2.PaymentMethod method,
    required String payee,
    int? bankAccountId,
    _i3.BankAccount? bankAccount,
    int? parentId,
    _i4.Parent? parent,
  }) = _PaymentImpl;

  factory Payment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Payment(
      id: jsonSerialization['id'] as int?,
      amount: jsonSerialization['amount'] as int,
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
      parentId: jsonSerialization['parentId'] as int?,
      parent: jsonSerialization['parent'] == null
          ? null
          : _i4.Parent.fromJson(
              (jsonSerialization['parent'] as Map<String, dynamic>)),
    );
  }

  static final t = PaymentTable();

  static const db = PaymentRepository._();

  @override
  int? id;

  int amount;

  DateTime date;

  String reference;

  _i2.PaymentMethod method;

  String payee;

  int? bankAccountId;

  _i3.BankAccount? bankAccount;

  int? parentId;

  _i4.Parent? parent;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Payment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Payment copyWith({
    int? id,
    int? amount,
    DateTime? date,
    String? reference,
    _i2.PaymentMethod? method,
    String? payee,
    int? bankAccountId,
    _i3.BankAccount? bankAccount,
    int? parentId,
    _i4.Parent? parent,
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
      if (parentId != null) 'parentId': parentId,
      if (parent != null) 'parent': parent?.toJson(),
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
      'payee': payee,
      if (bankAccountId != null) 'bankAccountId': bankAccountId,
      if (bankAccount != null) 'bankAccount': bankAccount?.toJsonForProtocol(),
      if (parentId != null) 'parentId': parentId,
      if (parent != null) 'parent': parent?.toJsonForProtocol(),
    };
  }

  static PaymentInclude include({
    _i3.BankAccountInclude? bankAccount,
    _i4.ParentInclude? parent,
  }) {
    return PaymentInclude._(
      bankAccount: bankAccount,
      parent: parent,
    );
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
    required int amount,
    required DateTime date,
    required String reference,
    required _i2.PaymentMethod method,
    required String payee,
    int? bankAccountId,
    _i3.BankAccount? bankAccount,
    int? parentId,
    _i4.Parent? parent,
  }) : super._(
          id: id,
          amount: amount,
          date: date,
          reference: reference,
          method: method,
          payee: payee,
          bankAccountId: bankAccountId,
          bankAccount: bankAccount,
          parentId: parentId,
          parent: parent,
        );

  /// Returns a shallow copy of this [Payment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Payment copyWith({
    Object? id = _Undefined,
    int? amount,
    DateTime? date,
    String? reference,
    _i2.PaymentMethod? method,
    String? payee,
    Object? bankAccountId = _Undefined,
    Object? bankAccount = _Undefined,
    Object? parentId = _Undefined,
    Object? parent = _Undefined,
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
      parentId: parentId is int? ? parentId : this.parentId,
      parent: parent is _i4.Parent? ? parent : this.parent?.copyWith(),
    );
  }
}

class PaymentTable extends _i1.Table<int?> {
  PaymentTable({super.tableRelation}) : super(tableName: 'payments') {
    amount = _i1.ColumnInt(
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
    payee = _i1.ColumnString(
      'payee',
      this,
    );
    bankAccountId = _i1.ColumnInt(
      'bankAccountId',
      this,
    );
    parentId = _i1.ColumnInt(
      'parentId',
      this,
    );
  }

  late final _i1.ColumnInt amount;

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnString reference;

  late final _i1.ColumnEnum<_i2.PaymentMethod> method;

  late final _i1.ColumnString payee;

  late final _i1.ColumnInt bankAccountId;

  _i3.BankAccountTable? _bankAccount;

  late final _i1.ColumnInt parentId;

  _i4.ParentTable? _parent;

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

  _i4.ParentTable get parent {
    if (_parent != null) return _parent!;
    _parent = _i1.createRelationTable(
      relationFieldName: 'parent',
      field: Payment.t.parentId,
      foreignField: _i4.Parent.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.ParentTable(tableRelation: foreignTableRelation),
    );
    return _parent!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        amount,
        date,
        reference,
        method,
        payee,
        bankAccountId,
        parentId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'bankAccount') {
      return bankAccount;
    }
    if (relationField == 'parent') {
      return parent;
    }
    return null;
  }
}

class PaymentInclude extends _i1.IncludeObject {
  PaymentInclude._({
    _i3.BankAccountInclude? bankAccount,
    _i4.ParentInclude? parent,
  }) {
    _bankAccount = bankAccount;
    _parent = parent;
  }

  _i3.BankAccountInclude? _bankAccount;

  _i4.ParentInclude? _parent;

  @override
  Map<String, _i1.Include?> get includes => {
        'bankAccount': _bankAccount,
        'parent': _parent,
      };

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

  /// Creates a relation between the given [Payment] and [Parent]
  /// by setting the [Payment]'s foreign key `parentId` to refer to the [Parent].
  Future<void> parent(
    _i1.Session session,
    Payment payment,
    _i4.Parent parent, {
    _i1.Transaction? transaction,
  }) async {
    if (payment.id == null) {
      throw ArgumentError.notNull('payment.id');
    }
    if (parent.id == null) {
      throw ArgumentError.notNull('parent.id');
    }

    var $payment = payment.copyWith(parentId: parent.id);
    await session.db.updateRow<Payment>(
      $payment,
      columns: [Payment.t.parentId],
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

  /// Detaches the relation between this [Payment] and the [Parent] set in `parent`
  /// by setting the [Payment]'s foreign key `parentId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> parent(
    _i1.Session session,
    Payment payment, {
    _i1.Transaction? transaction,
  }) async {
    if (payment.id == null) {
      throw ArgumentError.notNull('payment.id');
    }

    var $payment = payment.copyWith(parentId: null);
    await session.db.updateRow<Payment>(
      $payment,
      columns: [Payment.t.parentId],
      transaction: transaction,
    );
  }
}
