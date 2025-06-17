import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/payment_method.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:flutter_masked_text3/flutter_masked_text3.dart';

class AddPaymentDialog extends StatefulWidget {
  const AddPaymentDialog(
      {super.key,
      required this.onSubmit,
      this.initialPayment,
      this.parent,
      this.eventRegistration});
  final Function onSubmit;
  final Payment?
      initialPayment; // Optional initial payment data to pre-fill the form
  final Parent? parent; // Optional parent to associate with the payment
  final EventRegistration?
      eventRegistration; // Optional event registration to associate with the payment

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final MoneyMaskedTextController _amountController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: '', leftSymbol: '£');
  final TextEditingController _payeeController = TextEditingController();
  DateTime? _selectedDate;
  PaymentMethod? _selectedPaymentMethod = PaymentMethod.cash;
  final TextEditingController _referenceController = TextEditingController();

  void _initControllers() {
    if (widget.initialPayment != null) {
      final initialPayment = widget.initialPayment!;
      _amountController.updateValue(initialPayment.amount / 100);
      _payeeController.text = initialPayment.payee;
      _selectedDate = initialPayment.date;
      _selectedPaymentMethod = initialPayment.method;
      _referenceController.text = initialPayment.reference;
    }
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _payeeController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newPayment = Payment(
        amount: (_amountController.numberValue! * 100).truncate(),
        method: _selectedPaymentMethod ?? PaymentMethod.cash,
        payee: _payeeController.text,
        date: _selectedDate ?? DateTime.now(),
        reference: _referenceController.text,
      );
      if (widget.eventRegistration != null) {
        await client.payment.insertCashPayment(
          newPayment,
          widget.eventRegistration!,
        );
      } else {
        await client.payment.insertPayment(newPayment);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Payment added successfully'),
        ),
      );
      if (!mounted) return;
      widget.onSubmit();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          'Add ${(widget.parent != null) ? 'and Attribute ' : ''}Manual Payment'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              TextFormField(
                controller: _payeeController,
                decoration: const InputDecoration(labelText: 'Payee'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter payee name' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date chosen'
                          : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                autocorrect: true,
                controller: _referenceController,
                decoration: const InputDecoration(labelText: 'Reference'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a reference' : null,
                minLines: 1,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PaymentMethod>(
                value: _selectedPaymentMethod,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                items: PaymentMethod.values.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method.toDisplayString()),
                  );
                }).toList(),
                onChanged: (method) {
                  setState(() {
                    _selectedPaymentMethod = method;
                  });
                },
                validator: (value) =>
                    value == null ? 'Select a payment method' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
