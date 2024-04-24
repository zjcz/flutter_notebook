import 'package:flutter_notebook/app/notes/models/note_with_category_model.dart';
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_notebook/data/mapper/note_with_category_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test notes with category mapper', () {
    testWidgets('map single object', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
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
      Category category = Category(categoryId: categoryId, name: categoryName);
      NoteWithCategory noteWithCategory =
          NoteWithCategory(note: note, category: category);

      NoteWithCategoryModel noteWithCategoryModel =
          NoteWithCategoryMapper.mapToModel(noteWithCategory);

      expect(noteWithCategoryModel, isNotNull);
      expect(noteWithCategoryModel.note, isNotNull);
      expect(noteWithCategoryModel.note.noteId, noteId);
      expect(noteWithCategoryModel.note.title, title);
      expect(noteWithCategoryModel.note.description, description);
      expect(noteWithCategoryModel.note.categoryId, noteCategoryId);
      expect(noteWithCategoryModel.note.modifiedDate, modifiedDate);
      expect(noteWithCategoryModel.category, isNotNull);
      expect(noteWithCategoryModel.category!.categoryId, categoryId);
      expect(noteWithCategoryModel.category!.name, categoryName);
    });

    testWidgets('map list object object', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
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
      Category category = Category(categoryId: categoryId, name: categoryName);
      NoteWithCategory noteWithCategory =
          NoteWithCategory(note: note, category: category);

      List<NoteWithCategoryModel> noteWithCategoryModel =
          NoteWithCategoryMapper.mapToModelList([noteWithCategory]);

      expect(noteWithCategoryModel, isNotNull);
      expect(noteWithCategoryModel.length, 1);
      expect(noteWithCategoryModel[0].note, isNotNull);
      expect(noteWithCategoryModel[0].note.noteId, noteId);
      expect(noteWithCategoryModel[0].note.title, title);
      expect(noteWithCategoryModel[0].note.description, description);
      expect(noteWithCategoryModel[0].note.categoryId, noteCategoryId);
      expect(noteWithCategoryModel[0].note.modifiedDate, modifiedDate);
      expect(noteWithCategoryModel[0].category, isNotNull);
      expect(noteWithCategoryModel[0].category!.categoryId, categoryId);
      expect(noteWithCategoryModel[0].category!.name, categoryName);
    });
  });
}
