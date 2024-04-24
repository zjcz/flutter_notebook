import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';
import 'package:flutter_notebook/app/category/controllers/categories_controller.dart';

class CategoryDropdown extends ConsumerWidget {
  final int? categoryId;
  final Function(CategoryModel?) onChanged;
  final String noneNodeText;
  
  const CategoryDropdown(
      {super.key,
      this.categoryId,
      required this.onChanged,
      this.noneNodeText = '(none)'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesList = ref.watch(categoriesControllerProvider);

    return categoriesList.when(
      data: (categories) {
        return DropdownButtonFormField<CategoryModel?>(
            decoration: const InputDecoration(labelText: "Category"),
            value: categoryId == null
                ? null
                : categories.where((c) => c.categoryId == categoryId).first,
            items: [
              DropdownMenuItem<CategoryModel?>(
                key: const Key('none'),
                value: null,
                child: Text(noneNodeText),
              ),
              ...categories.map((c) {
                return DropdownMenuItem<CategoryModel?>(
                  key: Key(c.categoryId.toString()),
                  value: c,
                  child: Text(c.name),
                );
              })
            ],
            onChanged: onChanged);
      },
      error: (e, s) {
        debugPrintStack(label: e.toString(), stackTrace: s);
        return Center(child: Text('Error loading data: ${e.toString()}'));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
