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
import 'package:serverpod/protocol.dart' as _i2;
import 'bank_account.dart' as _i3;
import 'child.dart' as _i4;
import 'event_registration.dart' as _i5;
import 'events.dart' as _i6;
import 'group_colour.dart' as _i7;
import 'parent.dart' as _i8;
import 'payment.dart' as _i9;
import 'payment_method.dart' as _i10;
import 'scout_group.dart' as _i11;
import 'package:scouts_finances_server/src/generated/events.dart' as _i12;
import 'package:scouts_finances_server/src/generated/event_registration.dart'
    as _i13;
import 'package:scouts_finances_server/src/generated/parent.dart' as _i14;
import 'package:scouts_finances_server/src/generated/payment.dart' as _i15;
import 'package:scouts_finances_server/src/generated/scout_group.dart' as _i16;
import 'package:scouts_finances_server/src/generated/child.dart' as _i17;
export 'bank_account.dart';
export 'child.dart';
export 'event_registration.dart';
export 'events.dart';
export 'group_colour.dart';
export 'parent.dart';
export 'payment.dart';
export 'payment_method.dart';
export 'scout_group.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'bank_accounts',
      dartName: 'BankAccount',
      schema: 'public',
      module: 'scouts_finances',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'bank_accounts_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'accountNumber',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'sortCode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'parentId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'bank_accounts_fk_0',
          columns: ['parentId'],
          referenceTable: 'parents',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bank_accounts_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'children',
      dartName: 'Child',
      schema: 'public',
      module: 'scouts_finances',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'children_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'firstName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'lastName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'parentId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'scoutGroupId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'children_fk_0',
          columns: ['parentId'],
          referenceTable: 'parents',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'children_fk_1',
          columns: ['scoutGroupId'],
          referenceTable: 'scout_groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'children_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'event_registrations',
      dartName: 'EventRegistration',
      schema: 'public',
      module: 'scouts_finances',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'event_registrations_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'eventId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'childId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'paidDate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'event_registrations_fk_0',
          columns: ['eventId'],
          referenceTable: 'events',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'event_registrations_fk_1',
          columns: ['childId'],
          referenceTable: 'children',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'event_registrations_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'registration_index_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'eventId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'childId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'events',
      dartName: 'Event',
      schema: 'public',
      module: 'scouts_finances',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'events_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'date',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'cost',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'scoutGroupId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'events_fk_0',
          columns: ['scoutGroupId'],
          referenceTable: 'scout_groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'events_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'parents',
      dartName: 'Parent',
      schema: 'public',
      module: 'scouts_finances',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'parents_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'firstName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'lastName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'phone',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'balance',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'parents_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'payments',
      dartName: 'Payment',
      schema: 'public',
      module: 'scouts_finances',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'payments_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'date',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'reference',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'method',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:PaymentMethod',
        ),
        _i2.ColumnDefinition(
          name: 'payee',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'bankAccountId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'parentId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'payments_fk_0',
          columns: ['bankAccountId'],
          referenceTable: 'bank_accounts',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'payments_fk_1',
          columns: ['parentId'],
          referenceTable: 'parents',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'payments_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'scout_groups',
      dartName: 'ScoutGroup',
      schema: 'public',
      module: 'scouts_finances',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'scout_groups_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'colour',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:GroupColour',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scout_groups_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    ..._i2.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i3.BankAccount) {
      return _i3.BankAccount.fromJson(data) as T;
    }
    if (t == _i4.Child) {
      return _i4.Child.fromJson(data) as T;
    }
    if (t == _i5.EventRegistration) {
      return _i5.EventRegistration.fromJson(data) as T;
    }
    if (t == _i6.Event) {
      return _i6.Event.fromJson(data) as T;
    }
    if (t == _i7.GroupColour) {
      return _i7.GroupColour.fromJson(data) as T;
    }
    if (t == _i8.Parent) {
      return _i8.Parent.fromJson(data) as T;
    }
    if (t == _i9.Payment) {
      return _i9.Payment.fromJson(data) as T;
    }
    if (t == _i10.PaymentMethod) {
      return _i10.PaymentMethod.fromJson(data) as T;
    }
    if (t == _i11.ScoutGroup) {
      return _i11.ScoutGroup.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.BankAccount?>()) {
      return (data != null ? _i3.BankAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Child?>()) {
      return (data != null ? _i4.Child.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.EventRegistration?>()) {
      return (data != null ? _i5.EventRegistration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Event?>()) {
      return (data != null ? _i6.Event.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.GroupColour?>()) {
      return (data != null ? _i7.GroupColour.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Parent?>()) {
      return (data != null ? _i8.Parent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Payment?>()) {
      return (data != null ? _i9.Payment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.PaymentMethod?>()) {
      return (data != null ? _i10.PaymentMethod.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ScoutGroup?>()) {
      return (data != null ? _i11.ScoutGroup.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i3.BankAccount>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i3.BankAccount>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i4.Child>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i4.Child>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i4.Child>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i4.Child>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i6.Event>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i6.Event>(e)).toList()
          : null) as T;
    }
    if (t == List<_i12.Event>) {
      return (data as List).map((e) => deserialize<_i12.Event>(e)).toList()
          as T;
    }
    if (t == Map<int, (int, int)>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
          deserialize<int>(e['k']), deserialize<(int, int)>(e['v'])))) as T;
    }
    if (t == _i1.getType<(int, int)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<int>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<(int, int)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<int>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<(_i12.Event, List<_i13.EventRegistration>)>()) {
      return (
        deserialize<_i12.Event>(((data as Map)['p'] as List)[0]),
        deserialize<List<_i13.EventRegistration>>(data['p'][1]),
      ) as T;
    }
    if (t == List<_i13.EventRegistration>) {
      return (data as List)
          .map((e) => deserialize<_i13.EventRegistration>(e))
          .toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i14.Parent>) {
      return (data as List).map((e) => deserialize<_i14.Parent>(e)).toList()
          as T;
    }
    if (t == List<_i15.Payment>) {
      return (data as List).map((e) => deserialize<_i15.Payment>(e)).toList()
          as T;
    }
    if (t == List<_i16.ScoutGroup>) {
      return (data as List).map((e) => deserialize<_i16.ScoutGroup>(e)).toList()
          as T;
    }
    if (t == List<_i17.Child>) {
      return (data as List).map((e) => deserialize<_i17.Child>(e)).toList()
          as T;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i3.BankAccount) {
      return 'BankAccount';
    }
    if (data is _i4.Child) {
      return 'Child';
    }
    if (data is _i5.EventRegistration) {
      return 'EventRegistration';
    }
    if (data is _i6.Event) {
      return 'Event';
    }
    if (data is _i7.GroupColour) {
      return 'GroupColour';
    }
    if (data is _i8.Parent) {
      return 'Parent';
    }
    if (data is _i9.Payment) {
      return 'Payment';
    }
    if (data is _i10.PaymentMethod) {
      return 'PaymentMethod';
    }
    if (data is _i11.ScoutGroup) {
      return 'ScoutGroup';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'BankAccount') {
      return deserialize<_i3.BankAccount>(data['data']);
    }
    if (dataClassName == 'Child') {
      return deserialize<_i4.Child>(data['data']);
    }
    if (dataClassName == 'EventRegistration') {
      return deserialize<_i5.EventRegistration>(data['data']);
    }
    if (dataClassName == 'Event') {
      return deserialize<_i6.Event>(data['data']);
    }
    if (dataClassName == 'GroupColour') {
      return deserialize<_i7.GroupColour>(data['data']);
    }
    if (dataClassName == 'Parent') {
      return deserialize<_i8.Parent>(data['data']);
    }
    if (dataClassName == 'Payment') {
      return deserialize<_i9.Payment>(data['data']);
    }
    if (dataClassName == 'PaymentMethod') {
      return deserialize<_i10.PaymentMethod>(data['data']);
    }
    if (dataClassName == 'ScoutGroup') {
      return deserialize<_i11.ScoutGroup>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i3.BankAccount:
        return _i3.BankAccount.t;
      case _i4.Child:
        return _i4.Child.t;
      case _i5.EventRegistration:
        return _i5.EventRegistration.t;
      case _i6.Event:
        return _i6.Event.t;
      case _i8.Parent:
        return _i8.Parent.t;
      case _i9.Payment:
        return _i9.Payment.t;
      case _i11.ScoutGroup:
        return _i11.ScoutGroup.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'scouts_finances';
}

/// Maps any `Record`s known to this [Protocol] to their JSON representation
///
/// Throws in case the record type is not known.
///
/// This method will return `null` (only) for `null` inputs.
Map<String, dynamic>? mapRecordToJson(Record? record) {
  if (record == null) {
    return null;
  }
  if (record is (int, int)) {
    return {
      "p": [
        record.$1,
        record.$2,
      ],
    };
  }
  if (record is (_i12.Event, List<_i13.EventRegistration>)) {
    return {
      "p": [
        record.$1,
        record.$2,
      ],
    };
  }
  throw Exception('Unsupported record type ${record.runtimeType}');
}

/// Maps container types (like [List], [Map], [Set]) containing [Record]s to their JSON representation.
///
/// It should not be called for [SerializableModel] types. These handle the "[Record] in container" mapping internally already.
///
/// It is only supposed to be called from generated protocol code.
///
/// Returns either a `List<dynamic>` (for List, Sets, and Maps with non-String keys) or a `Map<String, dynamic>` in case the input was a `Map<String, …>`.
Object? mapRecordContainingContainerToJson(Object obj) {
  if (obj is! Iterable && obj is! Map) {
    throw ArgumentError.value(
      obj,
      'obj',
      'The object to serialize should be of type List, Map, or Set',
    );
  }

  dynamic mapIfNeeded(Object? obj) {
    return switch (obj) {
      Record record => mapRecordToJson(record),
      Iterable iterable => mapRecordContainingContainerToJson(iterable),
      Map map => mapRecordContainingContainerToJson(map),
      Object? value => value,
    };
  }

  switch (obj) {
    case Map<String, dynamic>():
      return {
        for (var entry in obj.entries) entry.key: mapIfNeeded(entry.value),
      };
    case Map():
      return [
        for (var entry in obj.entries)
          {
            'k': mapIfNeeded(entry.key),
            'v': mapIfNeeded(entry.value),
          }
      ];

    case Iterable():
      return [
        for (var e in obj) mapIfNeeded(e),
      ];
  }

  return obj;
}
