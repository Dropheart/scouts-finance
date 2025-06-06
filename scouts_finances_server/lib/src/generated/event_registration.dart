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
import 'events.dart' as _i2;
import 'child.dart' as _i3;

abstract class EventRegistration
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  EventRegistration._({
    this.id,
    required this.eventId,
    this.event,
    required this.childId,
    this.child,
    this.paidDate,
  });

  factory EventRegistration({
    int? id,
    required int eventId,
    _i2.Event? event,
    required int childId,
    _i3.Child? child,
    DateTime? paidDate,
  }) = _EventRegistrationImpl;

  factory EventRegistration.fromJson(Map<String, dynamic> jsonSerialization) {
    return EventRegistration(
      id: jsonSerialization['id'] as int?,
      eventId: jsonSerialization['eventId'] as int,
      event: jsonSerialization['event'] == null
          ? null
          : _i2.Event.fromJson(
              (jsonSerialization['event'] as Map<String, dynamic>)),
      childId: jsonSerialization['childId'] as int,
      child: jsonSerialization['child'] == null
          ? null
          : _i3.Child.fromJson(
              (jsonSerialization['child'] as Map<String, dynamic>)),
      paidDate: jsonSerialization['paidDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['paidDate']),
    );
  }

  static final t = EventRegistrationTable();

  static const db = EventRegistrationRepository._();

  @override
  int? id;

  int eventId;

  _i2.Event? event;

  int childId;

  _i3.Child? child;

  DateTime? paidDate;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [EventRegistration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EventRegistration copyWith({
    int? id,
    int? eventId,
    _i2.Event? event,
    int? childId,
    _i3.Child? child,
    DateTime? paidDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'eventId': eventId,
      if (event != null) 'event': event?.toJson(),
      'childId': childId,
      if (child != null) 'child': child?.toJson(),
      if (paidDate != null) 'paidDate': paidDate?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'eventId': eventId,
      if (event != null) 'event': event?.toJsonForProtocol(),
      'childId': childId,
      if (child != null) 'child': child?.toJsonForProtocol(),
      if (paidDate != null) 'paidDate': paidDate?.toJson(),
    };
  }

  static EventRegistrationInclude include({
    _i2.EventInclude? event,
    _i3.ChildInclude? child,
  }) {
    return EventRegistrationInclude._(
      event: event,
      child: child,
    );
  }

  static EventRegistrationIncludeList includeList({
    _i1.WhereExpressionBuilder<EventRegistrationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EventRegistrationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EventRegistrationTable>? orderByList,
    EventRegistrationInclude? include,
  }) {
    return EventRegistrationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EventRegistration.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EventRegistration.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EventRegistrationImpl extends EventRegistration {
  _EventRegistrationImpl({
    int? id,
    required int eventId,
    _i2.Event? event,
    required int childId,
    _i3.Child? child,
    DateTime? paidDate,
  }) : super._(
          id: id,
          eventId: eventId,
          event: event,
          childId: childId,
          child: child,
          paidDate: paidDate,
        );

  /// Returns a shallow copy of this [EventRegistration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EventRegistration copyWith({
    Object? id = _Undefined,
    int? eventId,
    Object? event = _Undefined,
    int? childId,
    Object? child = _Undefined,
    Object? paidDate = _Undefined,
  }) {
    return EventRegistration(
      id: id is int? ? id : this.id,
      eventId: eventId ?? this.eventId,
      event: event is _i2.Event? ? event : this.event?.copyWith(),
      childId: childId ?? this.childId,
      child: child is _i3.Child? ? child : this.child?.copyWith(),
      paidDate: paidDate is DateTime? ? paidDate : this.paidDate,
    );
  }
}

class EventRegistrationTable extends _i1.Table<int?> {
  EventRegistrationTable({super.tableRelation})
      : super(tableName: 'event_registrations') {
    eventId = _i1.ColumnInt(
      'eventId',
      this,
    );
    childId = _i1.ColumnInt(
      'childId',
      this,
    );
    paidDate = _i1.ColumnDateTime(
      'paidDate',
      this,
    );
  }

  late final _i1.ColumnInt eventId;

  _i2.EventTable? _event;

  late final _i1.ColumnInt childId;

  _i3.ChildTable? _child;

  late final _i1.ColumnDateTime paidDate;

  _i2.EventTable get event {
    if (_event != null) return _event!;
    _event = _i1.createRelationTable(
      relationFieldName: 'event',
      field: EventRegistration.t.eventId,
      foreignField: _i2.Event.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EventTable(tableRelation: foreignTableRelation),
    );
    return _event!;
  }

  _i3.ChildTable get child {
    if (_child != null) return _child!;
    _child = _i1.createRelationTable(
      relationFieldName: 'child',
      field: EventRegistration.t.childId,
      foreignField: _i3.Child.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ChildTable(tableRelation: foreignTableRelation),
    );
    return _child!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        eventId,
        childId,
        paidDate,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'event') {
      return event;
    }
    if (relationField == 'child') {
      return child;
    }
    return null;
  }
}

class EventRegistrationInclude extends _i1.IncludeObject {
  EventRegistrationInclude._({
    _i2.EventInclude? event,
    _i3.ChildInclude? child,
  }) {
    _event = event;
    _child = child;
  }

  _i2.EventInclude? _event;

  _i3.ChildInclude? _child;

  @override
  Map<String, _i1.Include?> get includes => {
        'event': _event,
        'child': _child,
      };

  @override
  _i1.Table<int?> get table => EventRegistration.t;
}

class EventRegistrationIncludeList extends _i1.IncludeList {
  EventRegistrationIncludeList._({
    _i1.WhereExpressionBuilder<EventRegistrationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EventRegistration.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => EventRegistration.t;
}

class EventRegistrationRepository {
  const EventRegistrationRepository._();

  final attachRow = const EventRegistrationAttachRowRepository._();

  /// Returns a list of [EventRegistration]s matching the given query parameters.
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
  Future<List<EventRegistration>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EventRegistrationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EventRegistrationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EventRegistrationTable>? orderByList,
    _i1.Transaction? transaction,
    EventRegistrationInclude? include,
  }) async {
    return session.db.find<EventRegistration>(
      where: where?.call(EventRegistration.t),
      orderBy: orderBy?.call(EventRegistration.t),
      orderByList: orderByList?.call(EventRegistration.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [EventRegistration] matching the given query parameters.
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
  Future<EventRegistration?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EventRegistrationTable>? where,
    int? offset,
    _i1.OrderByBuilder<EventRegistrationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EventRegistrationTable>? orderByList,
    _i1.Transaction? transaction,
    EventRegistrationInclude? include,
  }) async {
    return session.db.findFirstRow<EventRegistration>(
      where: where?.call(EventRegistration.t),
      orderBy: orderBy?.call(EventRegistration.t),
      orderByList: orderByList?.call(EventRegistration.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [EventRegistration] by its [id] or null if no such row exists.
  Future<EventRegistration?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    EventRegistrationInclude? include,
  }) async {
    return session.db.findById<EventRegistration>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [EventRegistration]s in the list and returns the inserted rows.
  ///
  /// The returned [EventRegistration]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EventRegistration>> insert(
    _i1.Session session,
    List<EventRegistration> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EventRegistration>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EventRegistration] and returns the inserted row.
  ///
  /// The returned [EventRegistration] will have its `id` field set.
  Future<EventRegistration> insertRow(
    _i1.Session session,
    EventRegistration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EventRegistration>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EventRegistration]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EventRegistration>> update(
    _i1.Session session,
    List<EventRegistration> rows, {
    _i1.ColumnSelections<EventRegistrationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EventRegistration>(
      rows,
      columns: columns?.call(EventRegistration.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EventRegistration]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EventRegistration> updateRow(
    _i1.Session session,
    EventRegistration row, {
    _i1.ColumnSelections<EventRegistrationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EventRegistration>(
      row,
      columns: columns?.call(EventRegistration.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EventRegistration]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EventRegistration>> delete(
    _i1.Session session,
    List<EventRegistration> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EventRegistration>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EventRegistration].
  Future<EventRegistration> deleteRow(
    _i1.Session session,
    EventRegistration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EventRegistration>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EventRegistration>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EventRegistrationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EventRegistration>(
      where: where(EventRegistration.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EventRegistrationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EventRegistration>(
      where: where?.call(EventRegistration.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class EventRegistrationAttachRowRepository {
  const EventRegistrationAttachRowRepository._();

  /// Creates a relation between the given [EventRegistration] and [Event]
  /// by setting the [EventRegistration]'s foreign key `eventId` to refer to the [Event].
  Future<void> event(
    _i1.Session session,
    EventRegistration eventRegistration,
    _i2.Event event, {
    _i1.Transaction? transaction,
  }) async {
    if (eventRegistration.id == null) {
      throw ArgumentError.notNull('eventRegistration.id');
    }
    if (event.id == null) {
      throw ArgumentError.notNull('event.id');
    }

    var $eventRegistration = eventRegistration.copyWith(eventId: event.id);
    await session.db.updateRow<EventRegistration>(
      $eventRegistration,
      columns: [EventRegistration.t.eventId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [EventRegistration] and [Child]
  /// by setting the [EventRegistration]'s foreign key `childId` to refer to the [Child].
  Future<void> child(
    _i1.Session session,
    EventRegistration eventRegistration,
    _i3.Child child, {
    _i1.Transaction? transaction,
  }) async {
    if (eventRegistration.id == null) {
      throw ArgumentError.notNull('eventRegistration.id');
    }
    if (child.id == null) {
      throw ArgumentError.notNull('child.id');
    }

    var $eventRegistration = eventRegistration.copyWith(childId: child.id);
    await session.db.updateRow<EventRegistration>(
      $eventRegistration,
      columns: [EventRegistration.t.childId],
      transaction: transaction,
    );
  }
}
