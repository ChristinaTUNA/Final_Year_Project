import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/shopping_service.dart';
import '../models/shopping_item.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  int _selectedTab = 0; // 0 = Shopping, 1 = Pantry

  final List<ListItem> _pantry = <ListItem>[];

  List<ListItem> get _currentList => _selectedTab == 0
      ? ShoppingService.instance.items
          .map((s) => ListItem(
              name: s.name, quantity: s.quantity, brand: s.brand, done: s.done))
          .toList()
      : _pantry;

  void _toggleDone(int index) {
    if (_selectedTab == 0) {
      ShoppingService.instance.toggleDone(index);
    } else {
      setState(() => _currentList[index] =
          _currentList[index].copyWith(done: !_currentList[index].done));
    }
  }

  Future<void> _showAddDialog() async {
    final result = await showDialog<ListItem?>(
      context: context,
      builder: (context) => const _AddItemDialog(),
    );

    if (result != null) {
      ShoppingService.instance.addAll([
        ShoppingItem(
            name: result.name, quantity: result.quantity, brand: result.brand)
      ]);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE02200);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text('Lists',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.grey[500]),
            onPressed: () {
              // optional: implement bulk delete
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Tabs
            Row(
              children: [
                _PillTab(
                  label: 'Shopping',
                  selected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                const SizedBox(width: 12),
                _PillTab(
                  label: 'Pantry',
                  selected: _selectedTab == 1,
                  light: true,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Items list
            Expanded(
              child: AnimatedBuilder(
                animation: ShoppingService.instance,
                builder: (context, _) {
                  final list = _currentList;
                  return ListView.separated(
                    itemCount: list.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == list.length) {
                        // Add item row
                        return GestureDetector(
                          onTap: _showAddDialog,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 2),
                                ),
                                child: Icon(Icons.add,
                                    color: Colors.grey.shade400, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Text('Add item',
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey.shade400,
                                      fontSize: 16)),
                            ],
                          ),
                        );
                      }

                      final item = list[index];

                      return InkWell(
                        onTap: () => _toggleDone(index),
                        child: Row(
                          children: [
                            // Checkbox circle
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item.done ? red : Colors.transparent,
                                border: Border.all(
                                    color:
                                        item.done ? red : Colors.grey.shade300,
                                    width: 2),
                              ),
                              child: item.done
                                  ? const Icon(Icons.check,
                                      size: 18, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: item.done ? Colors.grey : Colors.black,
                                  decoration: item.done
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            if (item.quantity != null || item.brand != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${item.quantity ?? ''}${item.brand != null ? ' · ${item.brand}' : ''}',
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey.shade500,
                                      fontSize: 13),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillTab extends StatelessWidget {
  final String label;
  final bool selected;
  final bool light;
  final VoidCallback onTap;

  const _PillTab({
    required this.label,
    required this.selected,
    required this.onTap,
    this.light = false,
  });

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE02200);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? red
              : (light ? const Color(0xFFFFF1EF) : Colors.transparent),
          borderRadius: BorderRadius.circular(999),
          border: selected ? null : Border.all(color: Colors.transparent),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : const Color(0xFFE02200),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class ListItem {
  final String name;
  final String? quantity;
  final String? brand;
  final bool done;

  ListItem({required this.name, this.quantity, this.brand, this.done = false});

  ListItem copyWith(
      {String? name, String? quantity, String? brand, bool? done}) {
    return ListItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      brand: brand ?? this.brand,
      done: done ?? this.done,
    );
  }
}

class _AddItemDialog extends StatefulWidget {
  const _AddItemDialog();

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
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
            : _quantityController.text.trim(),
        brand: _brandController.text.trim().isEmpty
            ? null
            : _brandController.text.trim(),
      );

      Navigator.of(context).pop(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add item',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
            const SizedBox(height: 8),
            TextFormField(
              controller: _quantityController,
              decoration:
                  const InputDecoration(labelText: 'Quantity (optional)'),
            ),
            const SizedBox(height: 8),
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
            child: Text('Cancel', style: GoogleFonts.poppins())),
        FilledButton(
            onPressed: _submit,
            child:
                Text('Add', style: GoogleFonts.poppins(color: Colors.white))),
      ],
    );
  }
}
