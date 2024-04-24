import 'package:flutter/material.dart';
import 'package:flutter_notebook/app/notes/views/widgets/note_tile.dart';
import 'package:flutter_notebook/app/notes/models/note_with_category_model.dart';

/// A widget to show a list of notes
class NotesList extends StatelessWidget {
  final List<NoteWithCategoryModel> noteList;
  final Function(int) onEditNote;
  final Function(int) onDeleteNote;

  const NotesList(
      {super.key,
      required this.noteList,
      required this.onEditNote,
      required this.onDeleteNote});

  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty) {
      return const Center(
        child: Text('No notes found.  Click + to add one'),
      );
    } else {
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 5);
        },
        itemBuilder: (context, index) {
          NoteWithCategoryModel note = noteList[index];
          return NoteTile(
            key: ValueKey(note.note.noteId),
            note: note,
            onEditCallback: () {
              onEditNote(note.note.noteId!);
            },
            onDeleteCallback: () {
              onDeleteNote(note.note.noteId!);
            },
          );
        },
        itemCount: noteList.length,
      );
    }
  }
}
