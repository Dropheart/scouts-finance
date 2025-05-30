/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class BankAccount
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = BankAccountTable();

  static const db = BankAccountRepository._();

  @override
  int? id;

  String accountNumber;

  String sortCode;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'accountNumber': accountNumber,
      'sortCode': sortCode,
    };
  }

  static BankAccountInclude include() {
    return BankAccountInclude._();
  }

  static BankAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<BankAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BankAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BankAccountTable>? orderByList,
    BankAccountInclude? include,
  }) {
    return BankAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BankAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BankAccount.t),
      include: include,
    );
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

class BankAccountTable extends _i1.Table<int?> {
  BankAccountTable({super.tableRelation}) : super(tableName: 'bank_accounts') {
    accountNumber = _i1.ColumnString(
      'accountNumber',
      this,
    );
    sortCode = _i1.ColumnString(
      'sortCode',
      this,
    );
  }

  late final _i1.ColumnString accountNumber;

  late final _i1.ColumnString sortCode;

  @override
  List<_i1.Column> get columns => [
        id,
        accountNumber,
        sortCode,
      ];
}

class BankAccountInclude extends _i1.IncludeObject {
  BankAccountInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BankAccount.t;
}

class BankAccountIncludeList extends _i1.IncludeList {
  BankAccountIncludeList._({
    _i1.WhereExpressionBuilder<BankAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BankAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BankAccount.t;
}

class BankAccountRepository {
  const BankAccountRepository._();

  /// Returns a list of [BankAccount]s matching the given query parameters.
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
  Future<List<BankAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BankAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BankAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BankAccountTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BankAccount>(
      where: where?.call(BankAccount.t),
      orderBy: orderBy?.call(BankAccount.t),
      orderByList: orderByList?.call(BankAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BankAccount] matching the given query parameters.
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
  Future<BankAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BankAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<BankAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BankAccountTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BankAccount>(
      where: where?.call(BankAccount.t),
      orderBy: orderBy?.call(BankAccount.t),
      orderByList: orderByList?.call(BankAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BankAccount] by its [id] or null if no such row exists.
  Future<BankAccount?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BankAccount>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BankAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [BankAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BankAccount>> insert(
    _i1.Session session,
    List<BankAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BankAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BankAccount] and returns the inserted row.
  ///
  /// The returned [BankAccount] will have its `id` field set.
  Future<BankAccount> insertRow(
    _i1.Session session,
    BankAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BankAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BankAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BankAccount>> update(
    _i1.Session session,
    List<BankAccount> rows, {
    _i1.ColumnSelections<BankAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BankAccount>(
      rows,
      columns: columns?.call(BankAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BankAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BankAccount> updateRow(
    _i1.Session session,
    BankAccount row, {
    _i1.ColumnSelections<BankAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BankAccount>(
      row,
      columns: columns?.call(BankAccount.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BankAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BankAccount>> delete(
    _i1.Session session,
    List<BankAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BankAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BankAccount].
  Future<BankAccount> deleteRow(
    _i1.Session session,
    BankAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BankAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BankAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BankAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BankAccount>(
      where: where(BankAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BankAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BankAccount>(
      where: where?.call(BankAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
