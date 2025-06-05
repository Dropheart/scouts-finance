import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/payment_method.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:flutter_masked_text3/flutter_masked_text3.dart';

class AddPaymentDialog extends StatefulWidget {
  const AddPaymentDialog({super.key});

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final MoneyMaskedTextController _amountController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: '', leftSymbol: '£');
  final MoneyMaskedTextController _amountController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: '', leftSymbol: '£');
  final TextEditingController _payeeController = TextEditingController();
  DateTime? _selectedDate;
  PaymentMethod? _selectedPaymentMethod = PaymentMethod.cash;

  @override
  void dispose() {
    _amountController.dispose();
    _payeeController.dispose();
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

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      client.payment.insertPayment(
        (double.parse(_amountController.text.replaceFirst('£', '')) * 100)
            .truncate(),
        (double.parse(_amountController.text.replaceFirst('£', '')) * 100)
            .truncate(),
        _payeeController.text,
        _selectedDate,
      );
      Navigator.of(context).pop({
        'amount': double.parse(_amountController.text.replaceFirst('£', '')),
        'description': _payeeController.text,
        'date': _selectedDate,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Payment'),
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

// Usage example:
// showDialog(
//   context: context,
//   builder: (context) => const AddPaymentDialog(),
// );

