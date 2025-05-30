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
import 'package:scouts_finances_client/src/protocol/payment.dart' as _i5;
import 'protocol.dart' as _i6;

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

  _i2.Future<(_i3.Event, List<_i4.EventRegistration>)> getEventById(int id) =>
      caller.callServerEndpoint<(_i3.Event, List<_i4.EventRegistration>)>(
        'event',
        'getEventById',
        {'id': id},
      );
}

/// {@category Endpoint}
class EndpointPayment extends _i1.EndpointRef {
  EndpointPayment(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'payment';

  _i2.Future<List<_i5.Payment>> getPayments() =>
      caller.callServerEndpoint<List<_i5.Payment>>(
        'payment',
        'getPayments',
        {},
      );

  _i2.Future<List<_i5.Payment>> insertPayment(
    double amount,
    String payee,
  ) =>
      caller.callServerEndpoint<List<_i5.Payment>>(
        'payment',
        'insertPayment',
        {
          'amount': amount,
          'payee': payee,
        },
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
          _i6.Protocol(),
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
    payment = EndpointPayment(this);
  }

  late final EndpointAdmin admin;

  late final EndpointEvent event;

  late final EndpointPayment payment;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'admin': admin,
        'event': event,
        'payment': payment,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
