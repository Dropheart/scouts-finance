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
import 'child.dart' as _i2;
import 'events.dart' as _i3;

abstract class ScoutGroup implements _i1.SerializableModel {
  ScoutGroup._({
    this.id,
    required this.name,
    this.description,
    this.children,
    this.events,
  });

  factory ScoutGroup({
    int? id,
    required String name,
    String? description,
    List<_i2.Child>? children,
    List<_i3.Event>? events,
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
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? description;

  List<_i2.Child>? children;

  List<_i3.Event>? events;

  /// Returns a shallow copy of this [ScoutGroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScoutGroup copyWith({
    int? id,
    String? name,
    String? description,
    List<_i2.Child>? children,
    List<_i3.Event>? events,
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
    };
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
  }) : super._(
          id: id,
          name: name,
          description: description,
          children: children,
          events: events,
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
    );
  }
}
