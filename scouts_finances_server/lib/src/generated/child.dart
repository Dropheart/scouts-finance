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

abstract class Child implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Child._({
    this.id,
    required this.firstName,
    required this.lastName,
  });

  factory Child({
    int? id,
    required String firstName,
    required String lastName,
  }) = _ChildImpl;

  factory Child.fromJson(Map<String, dynamic> jsonSerialization) {
    return Child(
      id: jsonSerialization['id'] as int?,
      firstName: jsonSerialization['firstName'] as String,
      lastName: jsonSerialization['lastName'] as String,
    );
  }

  static final t = ChildTable();

  static const db = ChildRepository._();

  @override
  int? id;

  String firstName;

  String lastName;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Child]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Child copyWith({
    int? id,
    String? firstName,
    String? lastName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  static ChildInclude include() {
    return ChildInclude._();
  }

  static ChildIncludeList includeList({
    _i1.WhereExpressionBuilder<ChildTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChildTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChildTable>? orderByList,
    ChildInclude? include,
  }) {
    return ChildIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Child.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Child.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildImpl extends Child {
  _ChildImpl({
    int? id,
    required String firstName,
    required String lastName,
  }) : super._(
          id: id,
          firstName: firstName,
          lastName: lastName,
        );

  /// Returns a shallow copy of this [Child]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Child copyWith({
    Object? id = _Undefined,
    String? firstName,
    String? lastName,
  }) {
    return Child(
      id: id is int? ? id : this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}

class ChildTable extends _i1.Table<int?> {
  ChildTable({super.tableRelation}) : super(tableName: 'children') {
    firstName = _i1.ColumnString(
      'firstName',
      this,
    );
    lastName = _i1.ColumnString(
      'lastName',
      this,
    );
  }

  late final _i1.ColumnString firstName;

  late final _i1.ColumnString lastName;

  @override
  List<_i1.Column> get columns => [
        id,
        firstName,
        lastName,
      ];
}

class ChildInclude extends _i1.IncludeObject {
  ChildInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Child.t;
}

class ChildIncludeList extends _i1.IncludeList {
  ChildIncludeList._({
    _i1.WhereExpressionBuilder<ChildTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Child.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Child.t;
}

class ChildRepository {
  const ChildRepository._();

  /// Returns a list of [Child]s matching the given query parameters.
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
  Future<List<Child>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChildTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChildTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChildTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Child>(
      where: where?.call(Child.t),
      orderBy: orderBy?.call(Child.t),
      orderByList: orderByList?.call(Child.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Child] matching the given query parameters.
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
  Future<Child?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChildTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChildTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChildTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Child>(
      where: where?.call(Child.t),
      orderBy: orderBy?.call(Child.t),
      orderByList: orderByList?.call(Child.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Child] by its [id] or null if no such row exists.
  Future<Child?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Child>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Child]s in the list and returns the inserted rows.
  ///
  /// The returned [Child]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Child>> insert(
    _i1.Session session,
    List<Child> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Child>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Child] and returns the inserted row.
  ///
  /// The returned [Child] will have its `id` field set.
  Future<Child> insertRow(
    _i1.Session session,
    Child row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Child>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Child]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Child>> update(
    _i1.Session session,
    List<Child> rows, {
    _i1.ColumnSelections<ChildTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Child>(
      rows,
      columns: columns?.call(Child.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Child]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Child> updateRow(
    _i1.Session session,
    Child row, {
    _i1.ColumnSelections<ChildTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Child>(
      row,
      columns: columns?.call(Child.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Child]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Child>> delete(
    _i1.Session session,
    List<Child> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Child>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Child].
  Future<Child> deleteRow(
    _i1.Session session,
    Child row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Child>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Child>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChildTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Child>(
      where: where(Child.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChildTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Child>(
      where: where?.call(Child.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
