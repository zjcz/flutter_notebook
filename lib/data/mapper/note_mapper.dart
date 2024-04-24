import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_notebook/app/notes/models/note_model.dart';

class NoteMapper {
  static NoteModel mapToModel(Note note) {
    return NoteModel(
      noteId: note.noteId,
      title: note.title,
      description: note.description,
      categoryId: note.categoryId,
      modifiedDate: note.modifiedDate,
    );
  }

  static List<NoteModel> mapToModelList(List<Note> notes) {
    return notes.map((note) => mapToModel(note)).toList();
  }
}
