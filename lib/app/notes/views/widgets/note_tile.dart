import 'package:flutter/material.dart';
import 'package:flutter_notebook/app/notes/models/note_with_category_model.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';
import 'package:flutter_notebook/extensions/material_colors.dart';

/// A widget to show the note details in a [NotesList]
class NoteTile extends StatelessWidget {
  static const int descriptionPreviewLength = 100;
  final NoteWithCategoryModel note;
  final Function() onDeleteCallback;
  final Function() onEditCallback;

  const NoteTile(
      {super.key,
      required this.note,
      required this.onDeleteCallback,
      required this.onEditCallback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEditCallback,
      child: Card(
        color: context.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(5)),
        child: Container(
          padding: const EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.note.title,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(
                      note.note.description.substring(
                          0,
                          descriptionPreviewLength >
                                  note.note.description.length
                              ? note.note.description.length
                              : descriptionPreviewLength),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.normal)),
                  if (note.category != null)
                    buildCategoryChip(context, note.category!),
                ]),
            MenuAnchor(
              builder: (BuildContext context, MenuController controller,
                  Widget? child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'Show menu',
                );
              },
              menuChildren: [
                MenuItemButton(
                  onPressed: onDeleteCallback,
                  child: const Text('Remove'),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildCategoryChip(BuildContext context, CategoryModel category) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        border: Border.all(color: context.outline, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(category.name),
    );
  }
}
