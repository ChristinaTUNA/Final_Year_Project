import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookit/data/models/list_item.dart';
import 'viewmodel/lists_viewmodel.dart';
import 'widgets/add_item_dialog.dart';
import 'widgets/list_item_tile.dart';
import 'widgets/pill_tab.dart';

class ListsScreen extends ConsumerWidget {
  const ListsScreen({super.key});

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<ListItem?>(
      context: context,
      builder: (context) => const AddItemDialog(),
    );

    if (result != null) {
      ref.read(listsViewModelProvider.notifier).addItem(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listsViewModelProvider);
    final textTheme = Theme.of(context).textTheme;
    final list = state.currentList;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0, left: 16.0),
        child: FloatingActionButton(
          onPressed: () => _showAddDialog(context, ref),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              AppSpacing.pHorizontalLg.copyWith(top: AppSpacing.xl, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lists',
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  PillTab(
                    label: 'Shopping',
                    selected: state.selectedTab == 0,
                    onTap: () =>
                        ref.read(listsViewModelProvider.notifier).changeTab(0),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  PillTab(
                    label: 'Pantry',
                    selected: state.selectedTab == 1,
                    light: true,
                    onTap: () =>
                        ref.read(listsViewModelProvider.notifier).changeTab(1),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2. Logic: Show Empty State OR List
              Expanded(
                child: list.isEmpty
                    ? _buildEmptyState(context, state.selectedTab)
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 160),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 2),
                        itemBuilder: (context, index) {
                          final item = list[index];

                          // 3. Dismissible for Swipe-to-Delete
                          return Dismissible(
                            key: Key('${item.id}_$index'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.delete_outline,
                                  color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              ref
                                  .read(listsViewModelProvider.notifier)
                                  .deleteItem(index);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${item.name} removed'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      ref
                                          .read(listsViewModelProvider.notifier)
                                          .addItem(item);
                                    },
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: ListItemTile(
                              item: item,
                              onToggle: () => ref
                                  .read(listsViewModelProvider.notifier)
                                  .toggleDone(index),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 4. Empty State Widget
  Widget _buildEmptyState(BuildContext context, int tabIndex) {
    final isShopping = tabIndex == 0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isShopping ? Icons.shopping_cart_outlined : Icons.kitchen_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            isShopping ? 'Your shopping list is empty' : 'Your pantry is empty',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add items',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[400],
                ),
          ),
        ],
      ),
    );
  }
}
