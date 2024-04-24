import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_notebook/app/notes/controllers/notes_controller.dart';
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'notes_controller_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test notes controller', () {
    testWidgets('get the records', (tester) async {
      int noteId = 1;
      String title = 'title';
      String description = 'content';
      int? noteCategoryId = 5;
      DateTime modifiedDate = DateTime.now();

      Note note = Note(
          noteId: noteId,
          title: title,
          description: description,
          categoryId: noteCategoryId,
          modifiedDate: modifiedDate);

      final databaseService = MockDatabaseService();
      when(databaseService.listAllNotes())
          .thenAnswer((_) => Stream.value([note]));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final dataList =
          await container.read(notesControllerProvider.future);

      expect(dataList, isNotNull);
      expect(dataList.length, 1);
      expect(dataList[0].noteId, noteId);
      expect(dataList[0].title, title);
      expect(dataList[0].description, description);
      expect(dataList[0].categoryId, noteCategoryId);
      expect(dataList[0].modifiedDate, modifiedDate);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('save new record', (tester) async {
      int newNoteId = 3;
      int? noteId;
      String title = 'title';
      String description = 'content';
      int? noteCategoryId = 5;

      final databaseService = MockDatabaseService();
      when(databaseService.saveNote(
              id: noteId,
              title: title,
              description: description,
              categoryId: noteCategoryId))
          .thenAnswer((_) => Future.value(newNoteId));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(notesControllerProvider.notifier);
      int savedNoteId = await provider.saveNote(
          noteId: noteId,
          title: title,
          description: description,
          categoryId: noteCategoryId);

      verify(databaseService.saveNote(
              id: noteId,
              title: title,
              description: description,
              categoryId: noteCategoryId))
          .called(1);
      expect(savedNoteId, newNoteId);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('save existing record', (tester) async {
      int noteId = 1;
      String title = 'title';
      String description = 'content';
      int? noteCategoryId = 5;

      final databaseService = MockDatabaseService();
      when(databaseService.saveNote(
              id: noteId,
              title: title,
              description: description,
              categoryId: noteCategoryId))
          .thenAnswer((_) => Future.value(noteId));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(notesControllerProvider.notifier);
      int savedNoteId = await provider.saveNote(
          noteId: noteId,
          title: title,
          description: description,
          categoryId: noteCategoryId);

      verify(databaseService.saveNote(
              id: noteId,
              title: title,
              description: description,
              categoryId: noteCategoryId))
          .called(1);
      expect(savedNoteId, noteId);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('delete record', (tester) async {
      int noteId = 5;

      final databaseService = MockDatabaseService();
      when(databaseService.deleteNote(noteId))
          .thenAnswer((_) => Future.value(noteId));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(notesControllerProvider.notifier);
      int deletedNoteId = await provider.deleteNote(noteId: noteId);

      verify(databaseService.deleteNote(noteId)).called(1);
      expect(deletedNoteId, noteId);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });
  });
}

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
/// Taken from https://riverpod.dev/docs/essentials/testing
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}
