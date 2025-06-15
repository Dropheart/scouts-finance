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
import 'parent.dart' as _i2;
import 'scout_group.dart' as _i3;

abstract class Child implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Child._({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.parentId,
    this.parent,
    required this.scoutGroupId,
    this.scoutGroup,
  });

  factory Child({
    int? id,
    required String firstName,
    required String lastName,
    required int parentId,
    _i2.Parent? parent,
    required int scoutGroupId,
    _i3.ScoutGroup? scoutGroup,
  }) = _ChildImpl;

  factory Child.fromJson(Map<String, dynamic> jsonSerialization) {
    return Child(
      id: jsonSerialization['id'] as int?,
      firstName: jsonSerialization['firstName'] as String,
      lastName: jsonSerialization['lastName'] as String,
      parentId: jsonSerialization['parentId'] as int,
      parent: jsonSerialization['parent'] == null
          ? null
          : _i2.Parent.fromJson(
              (jsonSerialization['parent'] as Map<String, dynamic>)),
      scoutGroupId: jsonSerialization['scoutGroupId'] as int,
      scoutGroup: jsonSerialization['scoutGroup'] == null
          ? null
          : _i3.ScoutGroup.fromJson(
              (jsonSerialization['scoutGroup'] as Map<String, dynamic>)),
    );
  }

  static final t = ChildTable();

  static const db = ChildRepository._();

  @override
  int? id;

  String firstName;

  String lastName;

  int parentId;

  _i2.Parent? parent;

  int scoutGroupId;

  _i3.ScoutGroup? scoutGroup;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Child]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Child copyWith({
    int? id,
    String? firstName,
    String? lastName,
    int? parentId,
    _i2.Parent? parent,
    int? scoutGroupId,
    _i3.ScoutGroup? scoutGroup,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'parentId': parentId,
      if (parent != null) 'parent': parent?.toJson(),
      'scoutGroupId': scoutGroupId,
      if (scoutGroup != null) 'scoutGroup': scoutGroup?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'parentId': parentId,
      if (parent != null) 'parent': parent?.toJsonForProtocol(),
      'scoutGroupId': scoutGroupId,
      if (scoutGroup != null) 'scoutGroup': scoutGroup?.toJsonForProtocol(),
    };
  }

  static ChildInclude include({
    _i2.ParentInclude? parent,
    _i3.ScoutGroupInclude? scoutGroup,
  }) {
    return ChildInclude._(
      parent: parent,
      scoutGroup: scoutGroup,
    );
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
    required int parentId,
    _i2.Parent? parent,
    required int scoutGroupId,
    _i3.ScoutGroup? scoutGroup,
  }) : super._(
          id: id,
          firstName: firstName,
          lastName: lastName,
          parentId: parentId,
          parent: parent,
          scoutGroupId: scoutGroupId,
          scoutGroup: scoutGroup,
        );

  /// Returns a shallow copy of this [Child]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Child copyWith({
    Object? id = _Undefined,
    String? firstName,
    String? lastName,
    int? parentId,
    Object? parent = _Undefined,
    int? scoutGroupId,
    Object? scoutGroup = _Undefined,
  }) {
    return Child(
      id: id is int? ? id : this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      parentId: parentId ?? this.parentId,
      parent: parent is _i2.Parent? ? parent : this.parent?.copyWith(),
      scoutGroupId: scoutGroupId ?? this.scoutGroupId,
      scoutGroup: scoutGroup is _i3.ScoutGroup?
          ? scoutGroup
          : this.scoutGroup?.copyWith(),
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
    parentId = _i1.ColumnInt(
      'parentId',
      this,
    );
    scoutGroupId = _i1.ColumnInt(
      'scoutGroupId',
      this,
    );
  }

  late final _i1.ColumnString firstName;

  late final _i1.ColumnString lastName;

  late final _i1.ColumnInt parentId;

  _i2.ParentTable? _parent;

  late final _i1.ColumnInt scoutGroupId;

  _i3.ScoutGroupTable? _scoutGroup;

  _i2.ParentTable get parent {
    if (_parent != null) return _parent!;
    _parent = _i1.createRelationTable(
      relationFieldName: 'parent',
      field: Child.t.parentId,
      foreignField: _i2.Parent.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ParentTable(tableRelation: foreignTableRelation),
    );
    return _parent!;
  }

  _i3.ScoutGroupTable get scoutGroup {
    if (_scoutGroup != null) return _scoutGroup!;
    _scoutGroup = _i1.createRelationTable(
      relationFieldName: 'scoutGroup',
      field: Child.t.scoutGroupId,
      foreignField: _i3.ScoutGroup.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ScoutGroupTable(tableRelation: foreignTableRelation),
    );
    return _scoutGroup!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        firstName,
        lastName,
        parentId,
        scoutGroupId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'parent') {
      return parent;
    }
    if (relationField == 'scoutGroup') {
      return scoutGroup;
    }
    return null;
  }
}

class ChildInclude extends _i1.IncludeObject {
  ChildInclude._({
    _i2.ParentInclude? parent,
    _i3.ScoutGroupInclude? scoutGroup,
  }) {
    _parent = parent;
    _scoutGroup = scoutGroup;
  }

  _i2.ParentInclude? _parent;

  _i3.ScoutGroupInclude? _scoutGroup;

  @override
  Map<String, _i1.Include?> get includes => {
        'parent': _parent,
        'scoutGroup': _scoutGroup,
      };

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

  final attachRow = const ChildAttachRowRepository._();

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
    ChildInclude? include,
  }) async {
    return session.db.find<Child>(
      where: where?.call(Child.t),
      orderBy: orderBy?.call(Child.t),
      orderByList: orderByList?.call(Child.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    ChildInclude? include,
  }) async {
    return session.db.findFirstRow<Child>(
      where: where?.call(Child.t),
      orderBy: orderBy?.call(Child.t),
      orderByList: orderByList?.call(Child.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Child] by its [id] or null if no such row exists.
  Future<Child?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ChildInclude? include,
  }) async {
    return session.db.findById<Child>(
      id,
      transaction: transaction,
      include: include,
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

class ChildAttachRowRepository {
  const ChildAttachRowRepository._();

  /// Creates a relation between the given [Child] and [Parent]
  /// by setting the [Child]'s foreign key `parentId` to refer to the [Parent].
  Future<void> parent(
    _i1.Session session,
    Child child,
    _i2.Parent parent, {
    _i1.Transaction? transaction,
  }) async {
    if (child.id == null) {
      throw ArgumentError.notNull('child.id');
    }
    if (parent.id == null) {
      throw ArgumentError.notNull('parent.id');
    }

    var $child = child.copyWith(parentId: parent.id);
    await session.db.updateRow<Child>(
      $child,
      columns: [Child.t.parentId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Child] and [ScoutGroup]
  /// by setting the [Child]'s foreign key `scoutGroupId` to refer to the [ScoutGroup].
  Future<void> scoutGroup(
    _i1.Session session,
    Child child,
    _i3.ScoutGroup scoutGroup, {
    _i1.Transaction? transaction,
  }) async {
    if (child.id == null) {
      throw ArgumentError.notNull('child.id');
    }
    if (scoutGroup.id == null) {
      throw ArgumentError.notNull('scoutGroup.id');
    }

    var $child = child.copyWith(scoutGroupId: scoutGroup.id);
    await session.db.updateRow<Child>(
      $child,
      columns: [Child.t.scoutGroupId],
      transaction: transaction,
    );
  }
}
