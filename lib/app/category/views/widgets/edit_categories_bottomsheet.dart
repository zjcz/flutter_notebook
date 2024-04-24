import 'package:flutter/material.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';

class EditCategoriesBottomsheet extends StatefulWidget {
  final CategoryModel? category;
  final Function(CategoryModel) onSave;

  const EditCategoriesBottomsheet(
      {super.key, required this.category, required this.onSave});

  @override
  State<EditCategoriesBottomsheet> createState() =>
      _EditCategoriesBottomsheetState();
}

class _EditCategoriesBottomsheetState extends State<EditCategoriesBottomsheet> {
  final categoryNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      categoryNameController.text = widget.category!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.category == null ? "Add Category" : "Edit Category",
              style: Theme.of(context).textTheme.headlineMedium),
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                      autofocus: true,
                      controller: categoryNameController,
                      decoration:
                          const InputDecoration(labelText: "Category Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      }),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle),
                  tooltip: 'Save',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      widget.onSave(CategoryModel(
                          categoryId: widget.category?.categoryId,
                          name: categoryNameController.text));
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cancel),
                  tooltip: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
