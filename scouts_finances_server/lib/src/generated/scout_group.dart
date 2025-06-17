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
import 'child.dart' as _i2;
import 'events.dart' as _i3;
import 'group_colour.dart' as _i4;

abstract class ScoutGroup
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ScoutGroup._({
    this.id,
    required this.name,
    this.description,
    this.children,
    this.events,
    required this.colour,
  });

  factory ScoutGroup({
    int? id,
    required String name,
    String? description,
    List<_i2.Child>? children,
    List<_i3.Event>? events,
    required _i4.GroupColour colour,
  }) = _ScoutGroupImpl;

  factory ScoutGroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScoutGroup(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      children: (jsonSerialization['children'] as List?)
          ?.map((e) => _i2.Child.fromJson((e as Map<String, dynamic>)))
          .toList(),
      events: (jsonSerialization['events'] as List?)
          ?.map((e) => _i3.Event.fromJson((e as Map<String, dynamic>)))
          .toList(),
      colour: _i4.GroupColour.fromJson((jsonSerialization['colour'] as String)),
    );
  }

  static final t = ScoutGroupTable();

  static const db = ScoutGroupRepository._();

  @override
  int? id;

  String name;

  String? description;

  List<_i2.Child>? children;

  List<_i3.Event>? events;

  _i4.GroupColour colour;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScoutGroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScoutGroup copyWith({
    int? id,
    String? name,
    String? description,
    List<_i2.Child>? children,
    List<_i3.Event>? events,
    _i4.GroupColour? colour,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (children != null)
        'children': children?.toJson(valueToJson: (v) => v.toJson()),
      if (events != null)
        'events': events?.toJson(valueToJson: (v) => v.toJson()),
      'colour': colour.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (children != null)
        'children': children?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (events != null)
        'events': events?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'colour': colour.toJson(),
    };
  }

  static ScoutGroupInclude include({
    _i2.ChildIncludeList? children,
    _i3.EventIncludeList? events,
  }) {
    return ScoutGroupInclude._(
      children: children,
      events: events,
    );
  }

  static ScoutGroupIncludeList includeList({
    _i1.WhereExpressionBuilder<ScoutGroupTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScoutGroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScoutGroupTable>? orderByList,
    ScoutGroupInclude? include,
  }) {
    return ScoutGroupIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScoutGroup.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ScoutGroup.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScoutGroupImpl extends ScoutGroup {
  _ScoutGroupImpl({
    int? id,
    required String name,
    String? description,
    List<_i2.Child>? children,
    List<_i3.Event>? events,
    required _i4.GroupColour colour,
  }) : super._(
          id: id,
          name: name,
          description: description,
          children: children,
          events: events,
          colour: colour,
        );

  /// Returns a shallow copy of this [ScoutGroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScoutGroup copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    Object? children = _Undefined,
    Object? events = _Undefined,
    _i4.GroupColour? colour,
  }) {
    return ScoutGroup(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      children: children is List<_i2.Child>?
          ? children
          : this.children?.map((e0) => e0.copyWith()).toList(),
      events: events is List<_i3.Event>?
          ? events
          : this.events?.map((e0) => e0.copyWith()).toList(),
      colour: colour ?? this.colour,
    );
  }
}

class ScoutGroupTable extends _i1.Table<int?> {
  ScoutGroupTable({super.tableRelation}) : super(tableName: 'scout_groups') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    colour = _i1.ColumnEnum(
      'colour',
      this,
      _i1.EnumSerialization.byName,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  _i2.ChildTable? ___children;

  _i1.ManyRelation<_i2.ChildTable>? _children;

  _i3.EventTable? ___events;

  _i1.ManyRelation<_i3.EventTable>? _events;

  late final _i1.ColumnEnum<_i4.GroupColour> colour;

  _i2.ChildTable get __children {
    if (___children != null) return ___children!;
    ___children = _i1.createRelationTable(
      relationFieldName: '__children',
      field: ScoutGroup.t.id,
      foreignField: _i2.Child.t.scoutGroupId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChildTable(tableRelation: foreignTableRelation),
    );
    return ___children!;
  }

  _i3.EventTable get __events {
    if (___events != null) return ___events!;
    ___events = _i1.createRelationTable(
      relationFieldName: '__events',
      field: ScoutGroup.t.id,
      foreignField: _i3.Event.t.scoutGroupId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.EventTable(tableRelation: foreignTableRelation),
    );
    return ___events!;
  }

  _i1.ManyRelation<_i2.ChildTable> get children {
    if (_children != null) return _children!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'children',
      field: ScoutGroup.t.id,
      foreignField: _i2.Child.t.scoutGroupId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChildTable(tableRelation: foreignTableRelation),
    );
    _children = _i1.ManyRelation<_i2.ChildTable>(
      tableWithRelations: relationTable,
      table: _i2.ChildTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _children!;
  }

  _i1.ManyRelation<_i3.EventTable> get events {
    if (_events != null) return _events!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'events',
      field: ScoutGroup.t.id,
      foreignField: _i3.Event.t.scoutGroupId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.EventTable(tableRelation: foreignTableRelation),
    );
    _events = _i1.ManyRelation<_i3.EventTable>(
      tableWithRelations: relationTable,
      table: _i3.EventTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _events!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        description,
        colour,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'children') {
      return __children;
    }
    if (relationField == 'events') {
      return __events;
    }
    return null;
  }
}

class ScoutGroupInclude extends _i1.IncludeObject {
  ScoutGroupInclude._({
    _i2.ChildIncludeList? children,
    _i3.EventIncludeList? events,
  }) {
    _children = children;
    _events = events;
  }

  _i2.ChildIncludeList? _children;

  _i3.EventIncludeList? _events;

  @override
  Map<String, _i1.Include?> get includes => {
        'children': _children,
        'events': _events,
      };

  @override
  _i1.Table<int?> get table => ScoutGroup.t;
}

class ScoutGroupIncludeList extends _i1.IncludeList {
  ScoutGroupIncludeList._({
    _i1.WhereExpressionBuilder<ScoutGroupTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScoutGroup.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ScoutGroup.t;
}

class ScoutGroupRepository {
  const ScoutGroupRepository._();

  final attach = const ScoutGroupAttachRepository._();

  final attachRow = const ScoutGroupAttachRowRepository._();

  /// Returns a list of [ScoutGroup]s matching the given query parameters.
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
  Future<List<ScoutGroup>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScoutGroupTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScoutGroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScoutGroupTable>? orderByList,
    _i1.Transaction? transaction,
    ScoutGroupInclude? include,
  }) async {
    return session.db.find<ScoutGroup>(
      where: where?.call(ScoutGroup.t),
      orderBy: orderBy?.call(ScoutGroup.t),
      orderByList: orderByList?.call(ScoutGroup.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ScoutGroup] matching the given query parameters.
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
  Future<ScoutGroup?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScoutGroupTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScoutGroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScoutGroupTable>? orderByList,
    _i1.Transaction? transaction,
    ScoutGroupInclude? include,
  }) async {
    return session.db.findFirstRow<ScoutGroup>(
      where: where?.call(ScoutGroup.t),
      orderBy: orderBy?.call(ScoutGroup.t),
      orderByList: orderByList?.call(ScoutGroup.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ScoutGroup] by its [id] or null if no such row exists.
  Future<ScoutGroup?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ScoutGroupInclude? include,
  }) async {
    return session.db.findById<ScoutGroup>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ScoutGroup]s in the list and returns the inserted rows.
  ///
  /// The returned [ScoutGroup]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ScoutGroup>> insert(
    _i1.Session session,
    List<ScoutGroup> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ScoutGroup>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ScoutGroup] and returns the inserted row.
  ///
  /// The returned [ScoutGroup] will have its `id` field set.
  Future<ScoutGroup> insertRow(
    _i1.Session session,
    ScoutGroup row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScoutGroup>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ScoutGroup]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ScoutGroup>> update(
    _i1.Session session,
    List<ScoutGroup> rows, {
    _i1.ColumnSelections<ScoutGroupTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ScoutGroup>(
      rows,
      columns: columns?.call(ScoutGroup.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScoutGroup]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScoutGroup> updateRow(
    _i1.Session session,
    ScoutGroup row, {
    _i1.ColumnSelections<ScoutGroupTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScoutGroup>(
      row,
      columns: columns?.call(ScoutGroup.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ScoutGroup]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ScoutGroup>> delete(
    _i1.Session session,
    List<ScoutGroup> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScoutGroup>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ScoutGroup].
  Future<ScoutGroup> deleteRow(
    _i1.Session session,
    ScoutGroup row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScoutGroup>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ScoutGroup>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScoutGroupTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ScoutGroup>(
      where: where(ScoutGroup.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScoutGroupTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScoutGroup>(
      where: where?.call(ScoutGroup.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ScoutGroupAttachRepository {
  const ScoutGroupAttachRepository._();

  /// Creates a relation between this [ScoutGroup] and the given [Child]s
  /// by setting each [Child]'s foreign key `scoutGroupId` to refer to this [ScoutGroup].
  Future<void> children(
    _i1.Session session,
    ScoutGroup scoutGroup,
    List<_i2.Child> child, {
    _i1.Transaction? transaction,
  }) async {
    if (child.any((e) => e.id == null)) {
      throw ArgumentError.notNull('child.id');
    }
    if (scoutGroup.id == null) {
      throw ArgumentError.notNull('scoutGroup.id');
    }

    var $child =
        child.map((e) => e.copyWith(scoutGroupId: scoutGroup.id)).toList();
    await session.db.update<_i2.Child>(
      $child,
      columns: [_i2.Child.t.scoutGroupId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [ScoutGroup] and the given [Event]s
  /// by setting each [Event]'s foreign key `scoutGroupId` to refer to this [ScoutGroup].
  Future<void> events(
    _i1.Session session,
    ScoutGroup scoutGroup,
    List<_i3.Event> event, {
    _i1.Transaction? transaction,
  }) async {
    if (event.any((e) => e.id == null)) {
      throw ArgumentError.notNull('event.id');
    }
    if (scoutGroup.id == null) {
      throw ArgumentError.notNull('scoutGroup.id');
    }

    var $event =
        event.map((e) => e.copyWith(scoutGroupId: scoutGroup.id)).toList();
    await session.db.update<_i3.Event>(
      $event,
      columns: [_i3.Event.t.scoutGroupId],
      transaction: transaction,
    );
  }
}

class ScoutGroupAttachRowRepository {
  const ScoutGroupAttachRowRepository._();

  /// Creates a relation between this [ScoutGroup] and the given [Child]
  /// by setting the [Child]'s foreign key `scoutGroupId` to refer to this [ScoutGroup].
  Future<void> children(
    _i1.Session session,
    ScoutGroup scoutGroup,
    _i2.Child child, {
    _i1.Transaction? transaction,
  }) async {
    if (child.id == null) {
      throw ArgumentError.notNull('child.id');
    }
    if (scoutGroup.id == null) {
      throw ArgumentError.notNull('scoutGroup.id');
    }

    var $child = child.copyWith(scoutGroupId: scoutGroup.id);
    await session.db.updateRow<_i2.Child>(
      $child,
      columns: [_i2.Child.t.scoutGroupId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [ScoutGroup] and the given [Event]
  /// by setting the [Event]'s foreign key `scoutGroupId` to refer to this [ScoutGroup].
  Future<void> events(
    _i1.Session session,
    ScoutGroup scoutGroup,
    _i3.Event event, {
    _i1.Transaction? transaction,
  }) async {
    if (event.id == null) {
      throw ArgumentError.notNull('event.id');
    }
    if (scoutGroup.id == null) {
      throw ArgumentError.notNull('scoutGroup.id');
    }

    var $event = event.copyWith(scoutGroupId: scoutGroup.id);
    await session.db.updateRow<_i3.Event>(
      $event,
      columns: [_i3.Event.t.scoutGroupId],
      transaction: transaction,
    );
  }
}
