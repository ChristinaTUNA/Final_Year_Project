import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/list_item.dart';
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
      body: SafeArea(
        child: Padding(
          padding:
              AppSpacing.pHorizontalLg.copyWith(top: AppSpacing.xl, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lists',
                style: textTheme.displayLarge,
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
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.separated(
                  itemCount: list.length + 1,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    if (index == list.length) {
                      return GestureDetector(
                        onTap: () => _showAddDialog(context, ref),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.divider, width: 2),
                              ),
                              child: const Icon(Icons.add,
                                  color: AppColors.textLightGray, size: 20),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Add item',
                              style: textTheme.bodyLarge?.copyWith(
                                fontSize: 16,
                                color: AppColors.textLightGray,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final item = list[index];
                    return ListItemTile(
                      item: item,
                      onToggle: () => ref
                          .read(listsViewModelProvider.notifier)
                          .toggleDone(index),
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
}
