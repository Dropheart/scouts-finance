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

abstract class Parent implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ParentTable();

  static const db = ParentRepository._();

  @override
  int? id;

  String firstName;

  String lastName;

  String email;

  String phone;

  int balance;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'balance': balance,
    };
  }

  static ParentInclude include() {
    return ParentInclude._();
  }

  static ParentIncludeList includeList({
    _i1.WhereExpressionBuilder<ParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentTable>? orderByList,
    ParentInclude? include,
  }) {
    return ParentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Parent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Parent.t),
      include: include,
    );
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

class ParentTable extends _i1.Table<int?> {
  ParentTable({super.tableRelation}) : super(tableName: 'parents') {
    firstName = _i1.ColumnString(
      'firstName',
      this,
    );
    lastName = _i1.ColumnString(
      'lastName',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    balance = _i1.ColumnInt(
      'balance',
      this,
    );
  }

  late final _i1.ColumnString firstName;

  late final _i1.ColumnString lastName;

  late final _i1.ColumnString email;

  late final _i1.ColumnString phone;

  late final _i1.ColumnInt balance;

  @override
  List<_i1.Column> get columns => [
        id,
        firstName,
        lastName,
        email,
        phone,
        balance,
      ];
}

class ParentInclude extends _i1.IncludeObject {
  ParentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Parent.t;
}

class ParentIncludeList extends _i1.IncludeList {
  ParentIncludeList._({
    _i1.WhereExpressionBuilder<ParentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Parent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Parent.t;
}

class ParentRepository {
  const ParentRepository._();

  /// Returns a list of [Parent]s matching the given query parameters.
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
  Future<List<Parent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Parent>(
      where: where?.call(Parent.t),
      orderBy: orderBy?.call(Parent.t),
      orderByList: orderByList?.call(Parent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Parent] matching the given query parameters.
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
  Future<Parent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentTable>? where,
    int? offset,
    _i1.OrderByBuilder<ParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Parent>(
      where: where?.call(Parent.t),
      orderBy: orderBy?.call(Parent.t),
      orderByList: orderByList?.call(Parent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Parent] by its [id] or null if no such row exists.
  Future<Parent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Parent>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Parent]s in the list and returns the inserted rows.
  ///
  /// The returned [Parent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Parent>> insert(
    _i1.Session session,
    List<Parent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Parent>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Parent] and returns the inserted row.
  ///
  /// The returned [Parent] will have its `id` field set.
  Future<Parent> insertRow(
    _i1.Session session,
    Parent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Parent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Parent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Parent>> update(
    _i1.Session session,
    List<Parent> rows, {
    _i1.ColumnSelections<ParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Parent>(
      rows,
      columns: columns?.call(Parent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Parent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Parent> updateRow(
    _i1.Session session,
    Parent row, {
    _i1.ColumnSelections<ParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Parent>(
      row,
      columns: columns?.call(Parent.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Parent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Parent>> delete(
    _i1.Session session,
    List<Parent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Parent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Parent].
  Future<Parent> deleteRow(
    _i1.Session session,
    Parent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Parent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Parent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ParentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Parent>(
      where: where(Parent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Parent>(
      where: where?.call(Parent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
