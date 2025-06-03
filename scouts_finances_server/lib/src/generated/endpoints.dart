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
import '../admin.dart' as _i2;
import '../events.dart' as _i3;
import '../payments.dart' as _i4;
import '../scouts.dart' as _i5;
import 'package:scouts_finances_server/src/generated/protocol.dart' as _i6;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'admin': _i2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'event': _i3.EventEndpoint()
        ..initialize(
          server,
          'event',
          null,
        ),
      'payment': _i4.PaymentEndpoint()
        ..initialize(
          server,
          'payment',
          null,
        ),
      'scouts': _i5.ScoutsEndpoint()
        ..initialize(
          server,
          'scouts',
          null,
        ),
    };
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'resetDb': _i1.MethodConnector(
          name: 'resetDb',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).resetDb(session),
        )
      },
    );
    connectors['event'] = _i1.EndpointConnector(
      name: 'event',
      endpoint: endpoints['event']!,
      methodConnectors: {
        'getEvents': _i1.MethodConnector(
          name: 'getEvents',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _i3.EventEndpoint).getEvents(session),
        ),
        'getEventById': _i1.MethodConnector(
          name: 'getEventById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _i3.EventEndpoint)
                  .getEventById(
                    session,
                    params['id'],
                  )
                  .then((record) => _i6.mapRecordToJson(record)),
        ),
        'insertEvent': _i1.MethodConnector(
          name: 'insertEvent',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'cost': _i1.ParameterDescription(
              name: 'cost',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _i3.EventEndpoint).insertEvent(
            session,
            params['name'],
            params['cost'],
            params['date'],
          ),
        ),
      },
    );
    connectors['payment'] = _i1.EndpointConnector(
      name: 'payment',
      endpoint: endpoints['payment']!,
      methodConnectors: {
        'getPayments': _i1.MethodConnector(
          name: 'getPayments',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['payment'] as _i4.PaymentEndpoint)
                  .getPayments(session),
        ),
        'insertPayment': _i1.MethodConnector(
          name: 'insertPayment',
          params: {
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'payee': _i1.ParameterDescription(
              name: 'payee',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['payment'] as _i4.PaymentEndpoint).insertPayment(
            session,
            params['amount'],
            params['payee'],
            params['date'],
          ),
        ),
      },
    );
    connectors['scouts'] = _i1.EndpointConnector(
      name: 'scouts',
      endpoint: endpoints['scouts']!,
      methodConnectors: {
        'getChildren': _i1.MethodConnector(
          name: 'getChildren',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scouts'] as _i5.ScoutsEndpoint).getChildren(session),
        )
      },
    );
  }
}
