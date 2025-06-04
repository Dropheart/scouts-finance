import 'package:scouts_finances_client/scouts_finances_client.dart';

extension PaymentMethodToString on PaymentMethod {
  // Converts a string to a PaymentMethod enum value.
  String toDisplayString() {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bank_transfer:
        return 'Bank Transfer';
    }
  }
}