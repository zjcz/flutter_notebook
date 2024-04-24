import 'package:flutter/material.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';
import 'package:flutter_notebook/app/category/views/widgets/category_dropdown.dart';
import 'package:flutter_notebook/app/notes/models/note_model.dart';
import 'package:flutter_notebook/data/database/sort_order.dart';
import 'package:flutter_notebook/route_config.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_note_screen_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test adding / editing note', () {
    testWidgets('show the add new screen', (tester) async {
      final databaseService = createMockDatabaseService();

      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      expect(find.text('Add Note'), findsOneWidget);
      expect(find.bySemanticsLabel('Title'), findsOneWidget);
      expect(find.bySemanticsLabel('Description'), findsOneWidget);
      expect(find.widgetWithText(CategoryDropdown, "Category"), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Save"), findsOneWidget);
    });

    testWidgets('show the edit screen with an existing note', (tester) async {
      final databaseService = createMockDatabaseService();

      NoteModel note = const NoteModel(
          noteId: 1,
          title: "Test Note",
          description: "Test Description",
          categoryId: 1);

      await tester.pumpWidget(createEditScreen(note, databaseService));
      await tester.pumpAndSettle();

      expect(find.text('Edit Note'), findsOneWidget);
      expect(find.text(note.title), findsOneWidget);
      expect(find.text(note.description), findsOneWidget);
      expect(find.bySemanticsLabel('Title'), findsOneWidget);
      expect(find.bySemanticsLabel('Description'), findsOneWidget);
      expect(find.widgetWithText(CategoryDropdown, "Category"), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Save"), findsOneWidget);
    });
  });

  group('Test database interaction of add/edit pension screen', () {
    testWidgets('save add new pension record', (tester) async {
      final databaseService = createMockDatabaseService();
      int newNoteId = 5;
      NoteModel note = const NoteModel(
          noteId: null,
          title: "Test Note",
          description: "Test Description",
          categoryId: 1);

      when(databaseService.saveNote(
              id: null,
              title: note.title,
              description: note.description,
              categoryId: note.categoryId))
          .thenAnswer((_) async => Future.value(newNoteId));

      await tester.pumpWidget(createEditScreen(note, databaseService));
      await tester.pumpAndSettle();

      await tester.enterText(find.bySemanticsLabel('Title'), note.title);
      await tester.enterText(
          find.bySemanticsLabel('Description'), note.description);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(CategoryDropdown, "Category"));
      await tester.pumpAndSettle();
      await tester.tap(find
          .widgetWithText(
              DropdownMenuItem<CategoryModel?>,
              _categories
                  .where((c) => c.categoryId == note.categoryId!)
                  .first
                  .name)
          .last);
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      verify(databaseService.saveNote(
              id: null,
              title: note.title,
              description: note.description,
              categoryId: note.categoryId))
          .called(1);
    });

    testWidgets('update existing pension record', (tester) async {
      final databaseService = createMockDatabaseService();
      NoteModel originalNote = const NoteModel(
          noteId: 5,
          title: "Test Note",
          description: "Test Description",
          categoryId: 1);
      NoteModel newNote = const NoteModel(
          noteId: 5,
          title: "New Test Note",
          description: "New Test Description",
          categoryId: 3);

      when(databaseService.saveNote(
              id: newNote.noteId,
              title: newNote.title,
              description: newNote.description,
              categoryId: newNote.categoryId))
          .thenAnswer((_) async => Future.value(newNote.noteId));

      await tester.pumpWidget(createEditScreen(originalNote, databaseService));
      await tester.pumpAndSettle();

      await tester.enterText(find.bySemanticsLabel('Title'), newNote.title);
      await tester.enterText(
          find.bySemanticsLabel('Description'), newNote.description);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(CategoryDropdown, "Category"));
      await tester.pumpAndSettle();
      await tester.tap(find
          .widgetWithText(
              DropdownMenuItem<CategoryModel?>,
              _categories
                  .where((c) => c.categoryId == newNote.categoryId!)
                  .first
                  .name)
          .last);
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      verify(databaseService.saveNote(
              id: newNote.noteId,
              title: newNote.title,
              description: newNote.description,
              categoryId: newNote.categoryId))
          .called(1);
    });
  });

  group('Test validation of add/edit pension screen', () {
    testWidgets('validation should prevent empty title', (tester) async {
      String description = "Test Description";
      final databaseService = createMockDatabaseService();

      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      await tester.enterText(find.bySemanticsLabel('Description'), description);
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      expect(find.text("Please enter some text"), findsOneWidget);
    });

    testWidgets('validation should prevent empty description', (tester) async {
      String title = "Test Title";
      final databaseService = createMockDatabaseService();

      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      await tester.enterText(find.bySemanticsLabel('Title'), title);
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      expect(find.text("Please enter some text"), findsOneWidget);
    });
  });
}

List<Category> _categories = [
  const Category(categoryId: 1, name: "Category 1"),
  const Category(categoryId: 2, name: "Category 2"),
  const Category(categoryId: 3, name: "Category 3"),
];

// Create a mock databaseService object, with the listAllCategories mocked
DatabaseService createMockDatabaseService() {
  DatabaseService ds = MockDatabaseService();

  when(ds.listAllCategories()).thenAnswer((_) => Stream.value(_categories));
  when(ds.listNotesInCategory(null, SortOrder.az))
      .thenAnswer((_) => Stream.value([]));
  return ds;
}

/// Create the screen for testing
Widget createEditScreen(NoteModel? noteRecord, DatabaseService db) {
  // need to initialise with the routing as testing the save button triggers
  // a navigation event if successful, which would result in errors if not set up
  return ProviderScope(
      overrides: [
        DatabaseService.provider.overrideWithValue(db),
      ],
      child: MaterialApp.router(
        routerConfig: setupRouter(
            initialLocation: RouteDefs.editNote, initialExtra: noteRecord),
      ));
}
