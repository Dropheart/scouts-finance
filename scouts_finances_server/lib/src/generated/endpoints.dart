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
import '../parent.dart' as _i4;
import '../payments.dart' as _i5;
import '../scout_groups.dart' as _i6;
import '../scouts.dart' as _i7;
import 'package:scouts_finances_server/src/generated/protocol.dart' as _i8;
import 'package:serverpod/src/database/concepts/transaction.dart' as _i9;
import 'package:scouts_finances_server/src/generated/parent.dart' as _i10;
import 'package:scouts_finances_server/src/generated/payment.dart' as _i11;
import 'package:scouts_finances_server/src/generated/event_registration.dart'
    as _i12;
import 'package:scouts_finances_server/src/generated/group_colour.dart' as _i13;
import 'package:scouts_finances_server/src/generated/child.dart' as _i14;

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
      'parent': _i4.ParentEndpoint()
        ..initialize(
          server,
          'parent',
          null,
        ),
      'payment': _i5.PaymentEndpoint()
        ..initialize(
          server,
          'payment',
          null,
        ),
      'scoutGroups': _i6.ScoutGroupsEndpoint()
        ..initialize(
          server,
          'scoutGroups',
          null,
        ),
      'scouts': _i7.ScoutsEndpoint()
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
        'getPaidCounts': _i1.MethodConnector(
          name: 'getPaidCounts',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _i3.EventEndpoint)
                  .getPaidCounts(session)
                  .then((container) =>
                      _i8.mapRecordContainingContainerToJson(container)),
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
                  .then((record) => _i8.mapRecordToJson(record)),
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
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'groupId': _i1.ParameterDescription(
              name: 'groupId',
              type: _i1.getType<int>(),
              nullable: false,
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
            params['groupId'],
          ),
        ),
        'registerChildForEvent': _i1.MethodConnector(
          name: 'registerChildForEvent',
          params: {
            'eventId': _i1.ParameterDescription(
              name: 'eventId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'childId': _i1.ParameterDescription(
              name: 'childId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'transaction': _i1.ParameterDescription(
              name: 'transaction',
              type: _i1.getType<_i9.Transaction?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _i3.EventEndpoint).registerChildForEvent(
            session,
            params['eventId'],
            params['childId'],
            transaction: params['transaction'],
          ),
        ),
        'registerChildrenForEvent': _i1.MethodConnector(
          name: 'registerChildrenForEvent',
          params: {
            'eventId': _i1.ParameterDescription(
              name: 'eventId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'childIds': _i1.ParameterDescription(
              name: 'childIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _i3.EventEndpoint)
                  .registerChildrenForEvent(
            session,
            params['eventId'],
            params['childIds'],
          ),
        ),
        'unpaidEvents': _i1.MethodConnector(
          name: 'unpaidEvents',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _i3.EventEndpoint).unpaidEvents(session),
        ),
        'getRegistrationsByChildId': _i1.MethodConnector(
          name: 'getRegistrationsByChildId',
          params: {
            'childId': _i1.ParameterDescription(
              name: 'childId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _i3.EventEndpoint)
                  .getRegistrationsByChildId(
            session,
            params['childId'],
          ),
        ),
        'getRegistrationsByEventId': _i1.MethodConnector(
          name: 'getRegistrationsByEventId',
          params: {
            'eventId': _i1.ParameterDescription(
              name: 'eventId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _i3.EventEndpoint)
                  .getRegistrationsByEventId(
            session,
            params['eventId'],
          ),
        ),
        'updateEventRegistrations': _i1.MethodConnector(
          name: 'updateEventRegistrations',
          params: {
            'eventId': _i1.ParameterDescription(
              name: 'eventId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'childIds': _i1.ParameterDescription(
              name: 'childIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _i3.EventEndpoint)
                  .updateEventRegistrations(
            session,
            params['eventId'],
            params['childIds'],
          ),
        ),
        'sendReminders': _i1.MethodConnector(
          name: 'sendReminders',
          params: {
            'eventId': _i1.ParameterDescription(
              name: 'eventId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['event'] as _i3.EventEndpoint).sendReminders(
            session,
            params['eventId'],
          ),
        ),
        'eventStream': _i1.MethodStreamConnector(
          name: 'eventStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['event'] as _i3.EventEndpoint).eventStream(session),
        ),
      },
    );
    connectors['parent'] = _i1.EndpointConnector(
      name: 'parent',
      endpoint: endpoints['parent']!,
      methodConnectors: {
        'getParents': _i1.MethodConnector(
          name: 'getParents',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['parent'] as _i4.ParentEndpoint).getParents(session),
        ),
        'getParentById': _i1.MethodConnector(
          name: 'getParentById',
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
              (endpoints['parent'] as _i4.ParentEndpoint).getParentById(
            session,
            params['id'],
          ),
        ),
        'addBalance': _i1.MethodConnector(
          name: 'addBalance',
          params: {
            'parentId': _i1.ParameterDescription(
              name: 'parentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['parent'] as _i4.ParentEndpoint).addBalance(
            session,
            params['parentId'],
            params['amount'],
          ),
        ),
        'addParent': _i1.MethodConnector(
          name: 'addParent',
          params: {
            'parent': _i1.ParameterDescription(
              name: 'parent',
              type: _i1.getType<_i10.Parent>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['parent'] as _i4.ParentEndpoint).addParent(
            session,
            params['parent'],
          ),
        ),
        'getUnpaidEventRegistrations': _i1.MethodConnector(
          name: 'getUnpaidEventRegistrations',
          params: {
            'parentId': _i1.ParameterDescription(
              name: 'parentId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['parent'] as _i4.ParentEndpoint)
                  .getUnpaidEventRegistrations(
            session,
            params['parentId'],
          ),
        ),
        'remindParent': _i1.MethodConnector(
          name: 'remindParent',
          params: {
            'parentId': _i1.ParameterDescription(
              name: 'parentId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['parent'] as _i4.ParentEndpoint).remindParent(
            session,
            params['parentId'],
          ),
        ),
        'remindAllParents': _i1.MethodConnector(
          name: 'remindAllParents',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['parent'] as _i4.ParentEndpoint)
                  .remindAllParents(session),
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
              (endpoints['payment'] as _i5.PaymentEndpoint)
                  .getPayments(session),
        ),
        'insertPayment': _i1.MethodConnector(
          name: 'insertPayment',
          params: {
            'payment': _i1.ParameterDescription(
              name: 'payment',
              type: _i1.getType<_i11.Payment>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['payment'] as _i5.PaymentEndpoint).insertPayment(
            session,
            params['payment'],
          ),
        ),
        'getPaymentById': _i1.MethodConnector(
          name: 'getPaymentById',
          params: {
            'paymentId': _i1.ParameterDescription(
              name: 'paymentId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['payment'] as _i5.PaymentEndpoint).getPaymentById(
            session,
            params['paymentId'],
          ),
        ),
        'getPaymentsByParentId': _i1.MethodConnector(
          name: 'getPaymentsByParentId',
          params: {
            'parentId': _i1.ParameterDescription(
              name: 'parentId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['payment'] as _i5.PaymentEndpoint)
                  .getPaymentsByParentId(
            session,
            params['parentId'],
          ),
        ),
        'updatePayment': _i1.MethodConnector(
          name: 'updatePayment',
          params: {
            'paymentId': _i1.ParameterDescription(
              name: 'paymentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'parent': _i1.ParameterDescription(
              name: 'parent',
              type: _i1.getType<_i10.Parent>(),
              nullable: false,
            ),
            'transaction': _i1.ParameterDescription(
              name: 'transaction',
              type: _i1.getType<_i9.Transaction?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['payment'] as _i5.PaymentEndpoint).updatePayment(
            session,
            params['paymentId'],
            params['parent'],
            transaction: params['transaction'],
          ),
        ),
        'insertCashPayment': _i1.MethodConnector(
          name: 'insertCashPayment',
          params: {
            'payment': _i1.ParameterDescription(
              name: 'payment',
              type: _i1.getType<_i11.Payment>(),
              nullable: false,
            ),
            'eventReg': _i1.ParameterDescription(
              name: 'eventReg',
              type: _i1.getType<_i12.EventRegistration>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['payment'] as _i5.PaymentEndpoint).insertCashPayment(
            session,
            params['payment'],
            params['eventReg'],
          ),
        ),
        'paymentStream': _i1.MethodStreamConnector(
          name: 'paymentStream',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['payment'] as _i5.PaymentEndpoint)
                  .paymentStream(session),
        ),
      },
    );
    connectors['scoutGroups'] = _i1.EndpointConnector(
      name: 'scoutGroups',
      endpoint: endpoints['scoutGroups']!,
      methodConnectors: {
        'getScoutGroups': _i1.MethodConnector(
          name: 'getScoutGroups',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scoutGroups'] as _i6.ScoutGroupsEndpoint)
                  .getScoutGroups(session),
        ),
        'createScoutGroup': _i1.MethodConnector(
          name: 'createScoutGroup',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'colour': _i1.ParameterDescription(
              name: 'colour',
              type: _i1.getType<_i13.GroupColour>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scoutGroups'] as _i6.ScoutGroupsEndpoint)
                  .createScoutGroup(
            session,
            params['name'],
            params['colour'],
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
              (endpoints['scouts'] as _i7.ScoutsEndpoint).getChildren(session),
        ),
        'getChildrenOfParent': _i1.MethodConnector(
          name: 'getChildrenOfParent',
          params: {
            'parentId': _i1.ParameterDescription(
              name: 'parentId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scouts'] as _i7.ScoutsEndpoint).getChildrenOfParent(
            session,
            params['parentId'],
          ),
        ),
        'getChildById': _i1.MethodConnector(
          name: 'getChildById',
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
              (endpoints['scouts'] as _i7.ScoutsEndpoint).getChildById(
            session,
            params['id'],
          ),
        ),
        'addChild': _i1.MethodConnector(
          name: 'addChild',
          params: {
            'child': _i1.ParameterDescription(
              name: 'child',
              type: _i1.getType<_i14.Child>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scouts'] as _i7.ScoutsEndpoint).addChild(
            session,
            params['child'],
          ),
        ),
      },
    );
  }
}
