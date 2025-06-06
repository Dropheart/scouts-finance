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
import 'events.dart' as _i2;
import 'child.dart' as _i3;

abstract class EventRegistration implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int eventId;

  _i2.Event? event;

  int childId;

  _i3.Child? child;

  DateTime? paidDate;

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
