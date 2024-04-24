import 'package:flutter/material.dart';
import 'package:flutter_notebook/app/category/views/widgets/edit_categories_bottomsheet.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_notebook/widgets/delete_confirmation_dialog.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';
import 'package:flutter_notebook/app/category/controllers/categories_controller.dart';

/// This screen allows the user to view, add, edit and delete categories.
/// Data access is done through the DatabaseService provider.
/// Categories are added / edited through a popup bottom sheet (see showAddEditBottomSheet() method)
class ListCategoriesScreen extends ConsumerStatefulWidget {
  const ListCategoriesScreen({super.key});

  @override
  ConsumerState<ListCategoriesScreen> createState() =>
      _ListCategoriesScreenState();
}

class _ListCategoriesScreenState extends ConsumerState<ListCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final currentCategories = ref.watch(categoriesControllerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Manage Categories'), actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              showAddEditBottomSheet(context, null);
            },
          ),
        ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: currentCategories.when(
                  data: (categories) {
                    return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return ListTile(
                            title: Text(category.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    showAddEditBottomSheet(context, category);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    showAdaptiveDialog(
                                        context: context,
                                        builder: (_) =>
                                            DeleteConfirmationDialog(
                                                title: 'Remove this Category?',
                                                content:
                                                    'Are you sure you want to remove this category?',
                                                onConfirmDelete: () async {
                                                  ref
                                                      .read(
                                                          categoriesControllerProvider
                                                              .notifier)
                                                      .deleteCategory(
                                                          categoryId: category
                                                              .categoryId!);
                                                }));
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  error: (e, s) {
                    debugPrintStack(label: e.toString(), stackTrace: s);
                    return Center(
                        child: Text('Error loading data: ${e.toString()}'));
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// This shows an edit popup at the bottom of the screen, containing a single
  /// field to allow the user to add or edit the category name.
  void showAddEditBottomSheet(BuildContext context, CategoryModel? cat) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return EditCategoriesBottomsheet(
            category: cat,
            onSave: (category) {
              ref.read(categoriesControllerProvider.notifier).saveCategory(
                  categoryId: category.categoryId, name: category.name);
              Navigator.pop(context);
            });
      },
    );
  }
}
