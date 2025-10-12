import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/shopping_service.dart';
import '../models/shopping_item.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int _servings = 4;
  final List<_Ingredient> _ingredients = [
    _Ingredient(amount: '1 Tbsp', name: 'Canola Oil'),
    _Ingredient(amount: '1 Lb', name: 'Shrimp', note: 'Peeled And Deveined'),
    _Ingredient(amount: '1/2', name: 'Yellow Onion', note: 'Finely Chopped'),
  ];

  bool get _anySelected => _ingredients.any((i) => i.selected);
  bool _nutritionExpanded = false;

  void _toggleIngredient(int index) => setState(() => _ingredients[index] =
      _ingredients[index].copyWith(selected: !_ingredients[index].selected));

  void _addToShopping() {
    final items = _ingredients
        .where((i) => i.selected)
        .map((i) => ShoppingItem(name: i.name, quantity: i.amount))
        .toList();
    if (items.isEmpty) return;
    ShoppingService.instance.addAll(items);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Added ${items.length} items to shopping list')));
    setState(() => _ingredients.replaceRange(0, _ingredients.length,
        _ingredients.map((i) => i.copyWith(selected: false)).toList()));
  }

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE02200);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/indian_shrimp_curry.jpg',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) =>
                    Container(height: 220, color: Colors.grey.shade200),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Indian Shrimp Curry',
                            style: GoogleFonts.poppins(
                                fontSize: 20, fontWeight: FontWeight.w700)),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.bookmark_border,
                              color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Row(
                          children: List.generate(
                              5,
                              (i) => const Icon(Icons.star,
                                  color: Color(0xFFFF6B3A),
                                  size: 16))).wrapWithSpacing(6),
                      const SizedBox(width: 8),
                      const Text('5',
                          style: TextStyle(color: Color(0xFFFF6B3A))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Servings control
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() =>
                            _servings = (_servings > 1) ? _servings - 1 : 1),
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Color(0xFF9CA3AF)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300)),
                        child: Text('$_servings',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _servings++),
                        icon: const Icon(Icons.add_circle_outline,
                            color: Color(0xFF9CA3AF)),
                      ),
                      const SizedBox(width: 8),
                      Text('Servings',
                          style:
                              GoogleFonts.poppins(color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Ingredients header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ingredients',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      IconButton(
                          icon: Icon(_nutritionExpanded
                              ? Icons.expand_less
                              : Icons.expand_more),
                          onPressed: () => setState(
                              () => _nutritionExpanded = !_nutritionExpanded)),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Column(
                    children: List.generate(_ingredients.length, (i) {
                      final ing = _ingredients[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Checkbox(
                                value: ing.selected,
                                onChanged: (_) => _toggleIngredient(i)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${ing.amount}  ${ing.name}',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600)),
                                  if (ing.note != null)
                                    Text(ing.note!,
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey.shade500,
                                            fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _anySelected ? _addToShopping : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _anySelected ? red : Colors.grey.shade200,
                        foregroundColor:
                            _anySelected ? Colors.white : Colors.grey.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Add to Shopping List',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Nutrition
                  ExpansionTile(
                    title: Text('Nutritions',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    trailing: const Text('100gr',
                        style: TextStyle(color: Colors.grey)),
                    onExpansionChanged: (v) =>
                        setState(() => _nutritionExpanded = v),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'Calories: 220 kcal\nProtein: 18g\nFat: 12g',
                            style: GoogleFonts.poppins(
                                color: Colors.grey.shade700)),
                      )
                    ],
                  ),

                  // Instructions
                  ExpansionTile(
                    title: Text('Instructions',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            '1. Heat oil in a pan.\n2. Saute onions until translucent.\n3. Add spices and shrimp, cook until done.',
                            style: GoogleFonts.poppins(
                                color: Colors.grey.shade700)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

extension _WidgetListExt on Widget {
  Widget wrapWithSpacing(double space) =>
      Row(children: [this, SizedBox(width: space)]);
}

class _Ingredient {
  final String amount;
  final String name;
  final String? note;
  final bool selected;

  _Ingredient(
      {required this.amount,
      required this.name,
      this.note,
      this.selected = false});

  _Ingredient copyWith(
          {String? amount, String? name, String? note, bool? selected}) =>
      _Ingredient(
        amount: amount ?? this.amount,
        name: name ?? this.name,
        note: note ?? this.note,
        selected: selected ?? this.selected,
      );
}
