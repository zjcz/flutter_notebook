import 'package:flutter/material.dart';
import 'package:flutter_notebook/extensions/material_colors.dart';
import 'package:flutter_notebook/app/notes/controllers/notes_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_notebook/app/category/views/widgets/category_dropdown.dart';
import 'package:flutter_notebook/route_config.dart';
import 'package:flutter_notebook/app/notes/models/note_model.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  static const noteTitleKey = Key('title');
  static const noteDescKey = Key('desc');

  final NoteModel? note;

  const EditNoteScreen({super.key, this.note});

  @override
  ConsumerState<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  int? categoryId;
  bool _unsavedChanges = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      titleController.text = widget.note!.title;
      descController.text = widget.note!.description;
      categoryId = widget.note!.categoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: context.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Text('Save',
                    style: TextStyle(
                      backgroundColor: context.primary,
                      color: context.onPrimary,
                    )),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (!await _saveData()) {
                      // an error occurred and we cannot save?
                      return;
                    }

                    if (!context.mounted) return;
                    context.pop();
                  }
                },
              ),
            ]),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            canPop: !_unsavedChanges,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }
              _showSaveChangesDialog();
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: EditNoteScreen.noteTitleKey,
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      _unsavedChanges = true;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: EditNoteScreen.noteDescKey,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 10,
                    controller: descController,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      _unsavedChanges = true;
                    },
                  ),
                  const SizedBox(height: 20),
                  CategoryDropdown(
                    categoryId: categoryId,
                    onChanged: (value) {
                      categoryId = value?.categoryId;
                      _unsavedChanges = true;
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text('Manage Categories',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                      onPressed: () async {
                        context.push(RouteDefs.manageCategories);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _saveData() async {
    final provider = ref.read(notesControllerProvider.notifier);

    provider.saveNote(
        noteId: widget.note?.noteId,
        title: titleController.text,
        description: descController.text,
        categoryId: categoryId);

    return true;
  }

  Future<void> _showSaveChangesDialog() async {
    final bool? shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Any unsaved changes will be lost!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes, discard my changes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('No, continue editing'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );

    if (shouldDiscard ?? false) {
      if (!mounted) return;
      context.pop();
    }
  }
}
