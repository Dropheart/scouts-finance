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
import 'dart:async' as _i2;
import 'package:scouts_finances_client/src/protocol/events.dart' as _i3;
import 'package:scouts_finances_client/src/protocol/event_registration.dart'
    as _i4;
import 'package:serverpod/src/database/concepts/transaction.dart' as _i5;
import 'package:scouts_finances_client/src/protocol/parent.dart' as _i6;
import 'package:scouts_finances_client/src/protocol/payment.dart' as _i7;
import 'package:scouts_finances_client/src/protocol/scout_group.dart' as _i8;
import 'package:scouts_finances_client/src/protocol/group_colour.dart' as _i9;
import 'package:scouts_finances_client/src/protocol/child.dart' as _i10;
import 'protocol.dart' as _i11;

/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _i2.Future<void> resetDb() => caller.callServerEndpoint<void>(
        'admin',
        'resetDb',
        {},
      );
}

/// {@category Endpoint}
class EndpointEvent extends _i1.EndpointRef {
  EndpointEvent(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'event';

  _i2.Future<List<_i3.Event>> getEvents() =>
      caller.callServerEndpoint<List<_i3.Event>>(
        'event',
        'getEvents',
        {},
      );

  _i2.Future<Map<int, (int, int)>> getPaidCounts() =>
      caller.callServerEndpoint<Map<int, (int, int)>>(
        'event',
        'getPaidCounts',
        {},
      );

  _i2.Future<(_i3.Event, List<_i4.EventRegistration>)> getEventById(int id) =>
      caller.callServerEndpoint<(_i3.Event, List<_i4.EventRegistration>)>(
        'event',
        'getEventById',
        {'id': id},
      );

  _i2.Future<List<_i3.Event>> insertEvent(
    String name,
    int cost,
    DateTime? date,
    int groupId,
  ) =>
      caller.callServerEndpoint<List<_i3.Event>>(
        'event',
        'insertEvent',
        {
          'name': name,
          'cost': cost,
          'date': date,
          'groupId': groupId,
        },
      );

  _i2.Future<_i4.EventRegistration> registerChildForEvent(
    int eventId,
    int childId, {
    _i5.Transaction? transaction,
  }) =>
      caller.callServerEndpoint<_i4.EventRegistration>(
        'event',
        'registerChildForEvent',
        {
          'eventId': eventId,
          'childId': childId,
          'transaction': transaction,
        },
      );

  _i2.Future<void> registerChildrenForEvent(
    int eventId,
    List<int> childIds,
  ) =>
      caller.callServerEndpoint<void>(
        'event',
        'registerChildrenForEvent',
        {
          'eventId': eventId,
          'childIds': childIds,
        },
      );

  _i2.Future<List<_i4.EventRegistration>> unpaidEvents() =>
      caller.callServerEndpoint<List<_i4.EventRegistration>>(
        'event',
        'unpaidEvents',
        {},
      );

  _i2.Future<List<_i4.EventRegistration>> getRegistrationsByChildId(
          int childId) =>
      caller.callServerEndpoint<List<_i4.EventRegistration>>(
        'event',
        'getRegistrationsByChildId',
        {'childId': childId},
      );

  _i2.Future<List<_i4.EventRegistration>> getRegistrationsByEventId(
          int eventId) =>
      caller.callServerEndpoint<List<_i4.EventRegistration>>(
        'event',
        'getRegistrationsByEventId',
        {'eventId': eventId},
      );
}

/// {@category Endpoint}
class EndpointParent extends _i1.EndpointRef {
  EndpointParent(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'parent';

  _i2.Future<List<_i6.Parent>> getParents() =>
      caller.callServerEndpoint<List<_i6.Parent>>(
        'parent',
        'getParents',
        {},
      );

  _i2.Future<_i6.Parent?> getParentById(int id) =>
      caller.callServerEndpoint<_i6.Parent?>(
        'parent',
        'getParentById',
        {'id': id},
      );

  _i2.Future<void> addBalance(
    int parentId,
    int amount,
  ) =>
      caller.callServerEndpoint<void>(
        'parent',
        'addBalance',
        {
          'parentId': parentId,
          'amount': amount,
        },
      );

  _i2.Future<void> addParent(_i6.Parent parent) =>
      caller.callServerEndpoint<void>(
        'parent',
        'addParent',
        {'parent': parent},
      );

  _i2.Future<List<_i4.EventRegistration>> getUnpaidEventRegistrations(
          int parentId) =>
      caller.callServerEndpoint<List<_i4.EventRegistration>>(
        'parent',
        'getUnpaidEventRegistrations',
        {'parentId': parentId},
      );

  _i2.Future<void> remindParent(int parentId) =>
      caller.callServerEndpoint<void>(
        'parent',
        'remindParent',
        {'parentId': parentId},
      );

  _i2.Future<void> remindAllParents() => caller.callServerEndpoint<void>(
        'parent',
        'remindAllParents',
        {},
      );
}

/// {@category Endpoint}
class EndpointPayment extends _i1.EndpointRef {
  EndpointPayment(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'payment';

  _i2.Future<List<_i7.Payment>> getPayments() =>
      caller.callServerEndpoint<List<_i7.Payment>>(
        'payment',
        'getPayments',
        {},
      );

  _i2.Future<List<_i7.Payment>> insertPayment(_i7.Payment payment) =>
      caller.callServerEndpoint<List<_i7.Payment>>(
        'payment',
        'insertPayment',
        {'payment': payment},
      );

  _i2.Future<_i7.Payment?> getPaymentById(int paymentId) =>
      caller.callServerEndpoint<_i7.Payment?>(
        'payment',
        'getPaymentById',
        {'paymentId': paymentId},
      );

  _i2.Future<List<_i7.Payment>> getPaymentsByParentId(int parentId) =>
      caller.callServerEndpoint<List<_i7.Payment>>(
        'payment',
        'getPaymentsByParentId',
        {'parentId': parentId},
      );

  _i2.Future<void> updatePayment(
    int paymentId,
    _i6.Parent parent, {
    _i5.Transaction? transaction,
  }) =>
      caller.callServerEndpoint<void>(
        'payment',
        'updatePayment',
        {
          'paymentId': paymentId,
          'parent': parent,
          'transaction': transaction,
        },
      );
}

/// {@category Endpoint}
class EndpointScoutGroups extends _i1.EndpointRef {
  EndpointScoutGroups(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'scoutGroups';

  _i2.Future<List<_i8.ScoutGroup>> getScoutGroups() =>
      caller.callServerEndpoint<List<_i8.ScoutGroup>>(
        'scoutGroups',
        'getScoutGroups',
        {},
      );

  _i2.Future<_i8.ScoutGroup> createScoutGroup(
    String name,
    _i9.GroupColour colour,
  ) =>
      caller.callServerEndpoint<_i8.ScoutGroup>(
        'scoutGroups',
        'createScoutGroup',
        {
          'name': name,
          'colour': colour,
        },
      );
}

/// {@category Endpoint}
class EndpointScouts extends _i1.EndpointRef {
  EndpointScouts(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'scouts';

  _i2.Future<List<_i10.Child>> getChildren() =>
      caller.callServerEndpoint<List<_i10.Child>>(
        'scouts',
        'getChildren',
        {},
      );

  _i2.Future<List<_i10.Child>> getChildrenOfParent(int parentId) =>
      caller.callServerEndpoint<List<_i10.Child>>(
        'scouts',
        'getChildrenOfParent',
        {'parentId': parentId},
      );

  _i2.Future<_i10.Child?> getChildById(int id) =>
      caller.callServerEndpoint<_i10.Child?>(
        'scouts',
        'getChildById',
        {'id': id},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i11.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    admin = EndpointAdmin(this);
    event = EndpointEvent(this);
    parent = EndpointParent(this);
    payment = EndpointPayment(this);
    scoutGroups = EndpointScoutGroups(this);
    scouts = EndpointScouts(this);
  }

  late final EndpointAdmin admin;

  late final EndpointEvent event;

  late final EndpointParent parent;

  late final EndpointPayment payment;

  late final EndpointScoutGroups scoutGroups;

  late final EndpointScouts scouts;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'admin': admin,
        'event': event,
        'parent': parent,
        'payment': payment,
        'scoutGroups': scoutGroups,
        'scouts': scouts,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
