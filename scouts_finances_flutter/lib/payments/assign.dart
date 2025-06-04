import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';

class AssignPaymentDialog extends StatefulWidget {
  const AssignPaymentDialog({super.key});

  @override
  State<AssignPaymentDialog> createState() => _AssignPaymentDialogState();
}

class _AssignPaymentDialogState extends State<AssignPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
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
        (double.parse(_amountController.text) * 100).truncate(),
        _payeeController.text,
        _selectedDate,
      );
      Navigator.of(context).pop({
        'amount': double.parse(_amountController.text),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
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
                    child: Text(method.name),
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
//   builder: (context) => const AssignPaymentDialog(),
// );
