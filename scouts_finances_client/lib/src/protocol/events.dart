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
import 'scout_group.dart' as _i2;

abstract class Event implements _i1.SerializableModel {
  Event._({
    this.id,
    required this.name,
    required this.date,
    required this.cost,
    required this.scoutGroupId,
    this.scoutGroup,
  });

  factory Event({
    int? id,
    required String name,
    required DateTime date,
    required int cost,
    required int scoutGroupId,
    _i2.ScoutGroup? scoutGroup,
  }) = _EventImpl;

  factory Event.fromJson(Map<String, dynamic> jsonSerialization) {
    return Event(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      cost: jsonSerialization['cost'] as int,
      scoutGroupId: jsonSerialization['scoutGroupId'] as int,
      scoutGroup: jsonSerialization['scoutGroup'] == null
          ? null
          : _i2.ScoutGroup.fromJson(
              (jsonSerialization['scoutGroup'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  DateTime date;

  int cost;

  int scoutGroupId;

  _i2.ScoutGroup? scoutGroup;

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Event copyWith({
    int? id,
    String? name,
    DateTime? date,
    int? cost,
    int? scoutGroupId,
    _i2.ScoutGroup? scoutGroup,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'date': date.toJson(),
      'cost': cost,
      'scoutGroupId': scoutGroupId,
      if (scoutGroup != null) 'scoutGroup': scoutGroup?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EventImpl extends Event {
  _EventImpl({
    int? id,
    required String name,
    required DateTime date,
    required int cost,
    required int scoutGroupId,
    _i2.ScoutGroup? scoutGroup,
  }) : super._(
          id: id,
          name: name,
          date: date,
          cost: cost,
          scoutGroupId: scoutGroupId,
          scoutGroup: scoutGroup,
        );

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Event copyWith({
    Object? id = _Undefined,
    String? name,
    DateTime? date,
    int? cost,
    int? scoutGroupId,
    Object? scoutGroup = _Undefined,
  }) {
    return Event(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      cost: cost ?? this.cost,
      scoutGroupId: scoutGroupId ?? this.scoutGroupId,
      scoutGroup: scoutGroup is _i2.ScoutGroup?
          ? scoutGroup
          : this.scoutGroup?.copyWith(),
    );
  }
}
