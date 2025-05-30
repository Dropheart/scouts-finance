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

abstract class Event implements _i1.SerializableModel {
  Event._({
    this.id,
    required this.name,
    required this.date,
    required this.cost,
  });

  factory Event({
    int? id,
    required String name,
    required DateTime date,
    required double cost,
  }) = _EventImpl;

  factory Event.fromJson(Map<String, dynamic> jsonSerialization) {
    return Event(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      cost: (jsonSerialization['cost'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  DateTime date;

  double cost;

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Event copyWith({
    int? id,
    String? name,
    DateTime? date,
    double? cost,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'date': date.toJson(),
      'cost': cost,
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
    required double cost,
  }) : super._(
          id: id,
          name: name,
          date: date,
          cost: cost,
        );

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Event copyWith({
    Object? id = _Undefined,
    String? name,
    DateTime? date,
    double? cost,
  }) {
    return Event(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      cost: cost ?? this.cost,
    );
  }
}
