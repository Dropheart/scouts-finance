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
import 'package:scouts_finances_client/src/protocol/parent.dart' as _i5;
import 'package:scouts_finances_client/src/protocol/payment.dart' as _i6;
import 'package:scouts_finances_client/src/protocol/child.dart' as _i7;
import 'protocol.dart' as _i8;

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
  ) =>
      caller.callServerEndpoint<List<_i3.Event>>(
        'event',
        'insertEvent',
        {
          'name': name,
          'cost': cost,
          'date': date,
        },
      );

  _i2.Future<_i4.EventRegistration> registerChildForEvent(
    int eventId,
    int childId,
  ) =>
      caller.callServerEndpoint<_i4.EventRegistration>(
        'event',
        'registerChildForEvent',
        {
          'eventId': eventId,
          'childId': childId,
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

  _i2.Future<List<_i5.Parent>> getParents() =>
      caller.callServerEndpoint<List<_i5.Parent>>(
        'parent',
        'getParents',
        {},
      );

  _i2.Future<_i5.Parent?> getParentById(int id) =>
      caller.callServerEndpoint<_i5.Parent?>(
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

  _i2.Future<void> addParent(_i5.Parent parent) =>
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

  _i2.Future<List<_i6.Payment>> getPayments() =>
      caller.callServerEndpoint<List<_i6.Payment>>(
        'payment',
        'getPayments',
        {},
      );

  _i2.Future<List<_i6.Payment>> insertPayment(_i6.Payment payment) =>
      caller.callServerEndpoint<List<_i6.Payment>>(
        'payment',
        'insertPayment',
        {'payment': payment},
      );

  _i2.Future<_i6.Payment?> getPaymentById(int paymentId) =>
      caller.callServerEndpoint<_i6.Payment?>(
        'payment',
        'getPaymentById',
        {'paymentId': paymentId},
      );

  _i2.Future<List<_i6.Payment>> getPaymentsByParentId(int parentId) =>
      caller.callServerEndpoint<List<_i6.Payment>>(
        'payment',
        'getPaymentsByParentId',
        {'parentId': parentId},
      );

  _i2.Future<void> updatePayment(
    int paymentId,
    _i5.Parent parent,
  ) =>
      caller.callServerEndpoint<void>(
        'payment',
        'updatePayment',
        {
          'paymentId': paymentId,
          'parent': parent,
        },
      );
}

/// {@category Endpoint}
class EndpointScouts extends _i1.EndpointRef {
  EndpointScouts(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'scouts';

  _i2.Future<List<_i7.Child>> getChildren() =>
      caller.callServerEndpoint<List<_i7.Child>>(
        'scouts',
        'getChildren',
        {},
      );

  _i2.Future<List<_i7.Child>> getChildrenOfParent(int parentId) =>
      caller.callServerEndpoint<List<_i7.Child>>(
        'scouts',
        'getChildrenOfParent',
        {'parentId': parentId},
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
          _i8.Protocol(),
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
    scouts = EndpointScouts(this);
  }

  late final EndpointAdmin admin;

  late final EndpointEvent event;

  late final EndpointParent parent;

  late final EndpointPayment payment;

  late final EndpointScouts scouts;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'admin': admin,
        'event': event,
        'parent': parent,
        'payment': payment,
        'scouts': scouts,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
