// lib/features/lists/widgets/add_item_dialog.dart
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../../../data/models/list_item.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _brandController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final item = ListItem(
          name: _nameController.text.trim(),
          quantity: _quantityController.text.trim().isEmpty
              ? null
              : _quantityController.text.trim());
      Navigator.of(context).pop(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text('Add item', style: textTheme.displayMedium),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ingredient name'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter a name'
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _quantityController,
              decoration:
                  const InputDecoration(labelText: 'Quantity (optional)'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Brand (optional)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
