import 'package:flutter/material.dart';

/// Displays a Confirmation box asking the user to confirm the deletion of an item
/// calls the callback function [onConfirmDelete] when the user confirms the deletion
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function onConfirmDelete;

  const DeleteConfirmationDialog(
      {super.key,
      required this.onConfirmDelete,
      this.title = 'Remove this Item?',
      this.content = 'Are you sure you want to remove this item?'});

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Confirm"),
      onPressed: () {
        onConfirmDelete();
        Navigator.pop(context, false);
      },
    );
    // set up the AlertDialog
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
}
