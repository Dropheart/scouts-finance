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
import 'bank_account.dart' as _i2;
import 'child.dart' as _i3;
import 'event_registration.dart' as _i4;
import 'events.dart' as _i5;
import 'parent.dart' as _i6;
import 'payment.dart' as _i7;
import 'payment_method.dart' as _i8;
import 'package:scouts_finances_client/src/protocol/events.dart' as _i9;
import 'package:scouts_finances_client/src/protocol/event_registration.dart'
    as _i10;
import 'package:scouts_finances_client/src/protocol/parent.dart' as _i11;
import 'package:scouts_finances_client/src/protocol/payment.dart' as _i12;
import 'package:scouts_finances_client/src/protocol/child.dart' as _i13;
export 'bank_account.dart';
export 'child.dart';
export 'event_registration.dart';
export 'events.dart';
export 'parent.dart';
export 'payment.dart';
export 'payment_method.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.BankAccount) {
      return _i2.BankAccount.fromJson(data) as T;
    }
    if (t == _i3.Child) {
      return _i3.Child.fromJson(data) as T;
    }
    if (t == _i4.EventRegistration) {
      return _i4.EventRegistration.fromJson(data) as T;
    }
    if (t == _i5.Event) {
      return _i5.Event.fromJson(data) as T;
    }
    if (t == _i6.Parent) {
      return _i6.Parent.fromJson(data) as T;
    }
    if (t == _i7.Payment) {
      return _i7.Payment.fromJson(data) as T;
    }
    if (t == _i8.PaymentMethod) {
      return _i8.PaymentMethod.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.BankAccount?>()) {
      return (data != null ? _i2.BankAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Child?>()) {
      return (data != null ? _i3.Child.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.EventRegistration?>()) {
      return (data != null ? _i4.EventRegistration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Event?>()) {
      return (data != null ? _i5.Event.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Parent?>()) {
      return (data != null ? _i6.Parent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Payment?>()) {
      return (data != null ? _i7.Payment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PaymentMethod?>()) {
      return (data != null ? _i8.PaymentMethod.fromJson(data) : null) as T;
    }
    if (t == List<_i9.Event>) {
      return (data as List).map((e) => deserialize<_i9.Event>(e)).toList() as T;
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
    if (t == _i1.getType<(_i9.Event, List<_i10.EventRegistration>)>()) {
      return (
        deserialize<_i9.Event>(((data as Map)['p'] as List)[0]),
        deserialize<List<_i10.EventRegistration>>(data['p'][1]),
      ) as T;
    }
    if (t == List<_i10.EventRegistration>) {
      return (data as List)
          .map((e) => deserialize<_i10.EventRegistration>(e))
          .toList() as T;
    }
    if (t == List<_i11.Parent>) {
      return (data as List).map((e) => deserialize<_i11.Parent>(e)).toList()
          as T;
    }
    if (t == List<_i12.Payment>) {
      return (data as List).map((e) => deserialize<_i12.Payment>(e)).toList()
          as T;
    }
    if (t == List<_i13.Child>) {
      return (data as List).map((e) => deserialize<_i13.Child>(e)).toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.BankAccount) {
      return 'BankAccount';
    }
    if (data is _i3.Child) {
      return 'Child';
    }
    if (data is _i4.EventRegistration) {
      return 'EventRegistration';
    }
    if (data is _i5.Event) {
      return 'Event';
    }
    if (data is _i6.Parent) {
      return 'Parent';
    }
    if (data is _i7.Payment) {
      return 'Payment';
    }
    if (data is _i8.PaymentMethod) {
      return 'PaymentMethod';
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
      return deserialize<_i2.BankAccount>(data['data']);
    }
    if (dataClassName == 'Child') {
      return deserialize<_i3.Child>(data['data']);
    }
    if (dataClassName == 'EventRegistration') {
      return deserialize<_i4.EventRegistration>(data['data']);
    }
    if (dataClassName == 'Event') {
      return deserialize<_i5.Event>(data['data']);
    }
    if (dataClassName == 'Parent') {
      return deserialize<_i6.Parent>(data['data']);
    }
    if (dataClassName == 'Payment') {
      return deserialize<_i7.Payment>(data['data']);
    }
    if (dataClassName == 'PaymentMethod') {
      return deserialize<_i8.PaymentMethod>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
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
  if (record is (_i9.Event, List<_i10.EventRegistration>)) {
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
