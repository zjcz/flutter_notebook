import 'package:flutter_notebook/app/notes/models/note_model.dart';
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_notebook/data/mapper/note_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test notes mapper', () {
    testWidgets('map single object', (tester) async {
      int noteId = 1;
      String title = 'title';
      String description = 'content';
      int? noteCategoryId = 6;
      DateTime modifiedDate = DateTime.now();

      Note note = Note(
          noteId: noteId,
          title: title,
          description: description,
          categoryId: noteCategoryId,
          modifiedDate: modifiedDate);

      NoteModel noteModel = NoteMapper.mapToModel(note);

      expect(noteModel, isNotNull);
      expect(noteModel.noteId, noteId);
      expect(noteModel.title, title);
      expect(noteModel.description, description);
      expect(noteModel.categoryId, noteCategoryId);
      expect(noteModel.modifiedDate, modifiedDate);
    });

    testWidgets('map list object object', (tester) async {
      int noteId = 1;
      String title = 'title';
      String description = 'content';
      int? noteCategoryId = 6;
      DateTime modifiedDate = DateTime.now();

      Note note = Note(
          noteId: noteId,
          title: title,
          description: description,
          categoryId: noteCategoryId,
          modifiedDate: modifiedDate);

      List<NoteModel> noteModel = NoteMapper.mapToModelList([note]);

      expect(noteModel, isNotNull);
      expect(noteModel.length, 1);
      expect(noteModel[0].noteId, noteId);
      expect(noteModel[0].title, title);
      expect(noteModel[0].description, description);
      expect(noteModel[0].categoryId, noteCategoryId);
      expect(noteModel[0].modifiedDate, modifiedDate);
    });
  });
}
