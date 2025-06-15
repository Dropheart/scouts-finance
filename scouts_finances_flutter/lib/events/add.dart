import 'package:flutter/material.dart';
import 'package:flutter_masked_text3/flutter_masked_text3.dart';
import 'package:provider/provider.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/services/scout_groups_service.dart';

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final MoneyMaskedTextController _priceController = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: '',
    leftSymbol: '£',
  );
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
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

  void _submit(int groupId) {
    if (formKey.currentState?.validate() ?? false) {
      client.event.insertEvent(
          _nameController.text,
          (double.parse(_priceController.text.replaceFirst('£', '')) * 100)
              .truncate(), // Convert to pence
          _selectedDate,
          groupId);
      Navigator.of(context).pop({
        'name': _nameController.text,
        'price': _priceController.text.replaceFirst('£', ''),
        'data': _selectedDate,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Add Event'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter event name'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Amount'),
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
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Consumer<ScoutGroupsService>(
              builder: (context, scoutGroupsService, child) {
            return ElevatedButton(
              onPressed: () =>
                  _submit(scoutGroupsService.currentScoutGroup.id!),
              child: const Text('Add'),
            );
          }),
        ]);
  }
}
