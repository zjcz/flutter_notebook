// Example on how to test your application's database code.
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_notebook/data/database/sort_order.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as match;

void main() {
  late DatabaseService database;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    database = DatabaseService(inMemory);
  });

  tearDown(() => database.close());

  group('Test Note CRUD methods', () {
    test('can get notes based on category', () async {
      final cat = await database.saveCategory(name: 'test 1');

      await database.saveNote(
          title: 'note title 1',
          description: 'test note entry 1',
          categoryId: cat);
      await database.saveNote(
          title: 'note title 2',
          description: 'test note entry 2',
          categoryId: cat);

      final result = await database.listNotesInCategory(cat).first;
      expect(result, match.isNotNull);
      expect(result.length, 2);
      expect(result[0].note.title, 'note title 1');
      expect(result[1].note.title, 'note title 2');
    });

    test('can get notes for a single category', () async {
      final cat1 = await database.saveCategory(name: 'test 1');
      final cat2 = await database.saveCategory(name: 'test 2');
      await database.saveNote(
          title: 'note title 1',
          description: 'test note entry 1',
          categoryId: cat1);
      await database.saveNote(
          title: 'note title 2',
          description: 'test note entry 2',
          categoryId: cat2);

      final result = await database.listNotesInCategory(cat1).first;
      expect(result, match.isNotNull);
      expect(result.length, 1);
      expect(result[0].note.title, 'note title 1');
    });

    test('can get all notes when no category specified', () async {
      final cat1 = await database.saveCategory(name: 'test 1');
      final cat2 = await database.saveCategory(name: 'test 2');
      await database.saveNote(
          title: 'note title 1',
          description: 'test note entry 1',
          categoryId: cat1);
      await database.saveNote(
          title: 'note title 2',
          description: 'test note entry 2',
          categoryId: cat2);

      final result = await database.listNotesInCategory(null).first;
      expect(result, match.isNotNull);
      expect(result.length, 2);
      expect(result[0].note.title, 'note title 1');
      expect(result[1].note.title, 'note title 2');
    });

    test('can update notes', () async {
      final cat1 = await database.saveCategory(name: 'test 1');
      final cat2 = await database.saveCategory(name: 'test 2');
      int noteId = await database.saveNote(
          title: 'note title 1',
          description: 'test note entry 1',
          categoryId: cat1);

      final result = await database.listNotesInCategory(null).first;
      expect(result, match.isNotNull);
      expect(result.length, 1);

      Note note = result[0].note;
      expect(note.noteId, noteId);
      expect(note.title, 'note title 1');
      expect(note.description, 'test note entry 1');
      expect(note.categoryId, cat1);

      // add a pause so that the modified date is different
      await Future.delayed(const Duration(seconds: 1));

      // now update
      await database.saveNote(
          id: noteId,
          title: 'note title 2',
          description: 'test note entry 2',
          categoryId: cat2);

      final resultAfterUpdate = await database.listNotesInCategory(null).first;
      expect(resultAfterUpdate, match.isNotNull);
      expect(resultAfterUpdate.length, 1);

      Note noteAfterUpdate = resultAfterUpdate[0].note;
      expect(noteAfterUpdate.noteId, noteId);
      expect(noteAfterUpdate.title, 'note title 2');
      expect(noteAfterUpdate.description, 'test note entry 2');
      expect(noteAfterUpdate.categoryId, cat2);
      expect(noteAfterUpdate.modifiedDate, isNot(equals(note.modifiedDate)));
    });

    test('can delete notes', () async {
      final cat = await database.saveCategory(name: 'test 1');
      int noteId = await database.saveNote(
          title: 'note title 1',
          description: 'test note entry 1',
          categoryId: cat);

      final result = await database.listNotesInCategory(null).first;
      expect(result, match.isNotNull);
      expect(result.length, 1);

      await database.deleteNote(noteId);

      final resultAfterDelete = await database.listNotesInCategory(null).first;
      expect(resultAfterDelete, match.isNotNull);
      expect(resultAfterDelete.length, 0);
    });
  });

  group('Test deleteCategory method', () {
    test('Deleting category does not delete note', () async {
      final categoryId = await database.saveCategory(name: 'test 1');
      await database.saveNote(
          title: 'note title 1',
          description: 'test note entry 1',
          categoryId: categoryId);

      final result = await database.listNotesInCategory(categoryId).first;
      expect(result, match.isNotNull);
      expect(result.length, 1);
      expect(result[0].note.categoryId, categoryId);
      expect(result[0].category, match.isNotNull);
      expect(result[0].category!.categoryId, categoryId);

      await database.deleteCategory(categoryId);

      final resultAfterDelete = await database.listNotesInCategory(null).first;
      expect(resultAfterDelete, match.isNotNull);
      expect(resultAfterDelete.length, 1);
      expect(resultAfterDelete[0].note.categoryId, null);
      expect(resultAfterDelete[0].category, null);
    });
  });

  group('Test sort order', () {
    test('can get notes in A to Z order', () async {
      final cat = await database.saveCategory(name: 'test 1');

      await database.saveNote(
          title: 'AAA Note', description: 'test note entry 1', categoryId: cat);
      await database.saveNote(
          title: 'CCC Note', description: 'test note entry 3', categoryId: cat);
      await database.saveNote(
          title: 'BBB Note', description: 'test note entry 2', categoryId: cat);

      final result =
          await database.listNotesInCategory(cat, SortOrder.az).first;
      expect(result, match.isNotNull);
      expect(result.length, 3);
      expect(result[0].note.title, 'AAA Note');
      expect(result[1].note.title, 'BBB Note');
      expect(result[2].note.title, 'CCC Note');
    });

    test('can get notes in Z to A order', () async {
      final cat = await database.saveCategory(name: 'test 1');

      await database.saveNote(
          title: 'AAA Note', description: 'test note entry 1', categoryId: cat);
      await database.saveNote(
          title: 'CCC Note', description: 'test note entry 3', categoryId: cat);
      await database.saveNote(
          title: 'BBB Note', description: 'test note entry 2', categoryId: cat);

      final result =
          await database.listNotesInCategory(cat, SortOrder.za).first;
      expect(result, match.isNotNull);
      expect(result.length, 3);
      expect(result[0].note.title, 'CCC Note');
      expect(result[1].note.title, 'BBB Note');
      expect(result[2].note.title, 'AAA Note');
    });

    test('can get notes in newest date order', () async {
      final cat = await database.saveCategory(name: 'test 1');

      // add a pause between saves so that the modified date is different
      await database.saveNote(
          title: 'AAA Note', description: 'test note entry 1', categoryId: cat);
      await Future.delayed(const Duration(seconds: 1));
      await database.saveNote(
          title: 'BBB Note', description: 'test note entry 2', categoryId: cat);
      await Future.delayed(const Duration(seconds: 1));
      await database.saveNote(
          title: 'CCC Note', description: 'test note entry 3', categoryId: cat);

      final result =
          await database.listNotesInCategory(cat, SortOrder.newest).first;
      expect(result, match.isNotNull);
      expect(result.length, 3);
      expect(result[0].note.title, 'CCC Note');
      expect(result[1].note.title, 'BBB Note');
      expect(result[2].note.title, 'AAA Note');
    });

    test('can get notes in olders date order', () async {
      final cat = await database.saveCategory(name: 'test 1');

      // add a pause between saves so that the modified date is different
      await database.saveNote(
          title: 'AAA Note', description: 'test note entry 1', categoryId: cat);
      await Future.delayed(const Duration(seconds: 1));
      await database.saveNote(
          title: 'BBB Note', description: 'test note entry 2', categoryId: cat);
      await Future.delayed(const Duration(seconds: 1));
      await database.saveNote(
          title: 'CCC Note', description: 'test note entry 3', categoryId: cat);

      final result =
          await database.listNotesInCategory(cat, SortOrder.oldest).first;
      expect(result, match.isNotNull);
      expect(result.length, 3);
      expect(result[0].note.title, 'AAA Note');
      expect(result[1].note.title, 'BBB Note');
      expect(result[2].note.title, 'CCC Note');
    });    
  });
}
