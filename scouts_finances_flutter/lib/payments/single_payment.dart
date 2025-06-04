import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/payments/payment_table.dart';

class SinglePaymentView extends StatefulWidget {
  final int paymentId;
  const SinglePaymentView({super.key, required this.paymentId});

  @override
  State<StatefulWidget> createState() => _SinglePaymentViewState();
}

class _SinglePaymentViewState extends State<SinglePaymentView> {
  late Payment? payment;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _getPayment();
  }

  void _getPayment() async {
    try {
      payment = await client.payment.getPaymentById(widget.paymentId);
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        payment = null; // Set to null if not found
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (payment == null) {
      return const Center(
        child: Text('Payment not found. This suggests there is an internal error. Please contact the developers.',
            style: TextStyle(color: Colors.red, fontSize: 16)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classify Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [PaymentTable(payment:  payment!)],
        ),
      ),
    );
  }
}