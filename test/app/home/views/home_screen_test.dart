import 'package:flutter/material.dart';
import 'package:flutter_notebook/app/category/views/list_categories_screen.dart';
import 'package:flutter_notebook/app/category/views/widgets/edit_categories_bottomsheet.dart';
import 'package:flutter_notebook/app/home/views/home_screen.dart';
import 'package:flutter_notebook/app/notes/views/edit_note_screen.dart';
import 'package:flutter_notebook/app/notes/views/widgets/note_tile.dart';
import 'package:flutter_notebook/app/notes/views/widgets/notes_list.dart';
import 'package:flutter_notebook/data/database/sort_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_notebook/route_config.dart';

import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_screen_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test displaying the screen', () {
    testWidgets('show the screen with no records', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([]));
      when(databaseService.listNotesInCategory(null, SortOrder.az))
          .thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(createScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("Notebook"), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.category), findsOneWidget);
      expect(find.byType(NotesList), findsOneWidget);
    });

    testWidgets('show the screen with a single record', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      int noteId = 1;
      String title = 'title';
      String description = 'content';
      int? noteCategoryId = categoryId;
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

      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([category]));
      when(databaseService.listNotesInCategory(null, SortOrder.az))
          .thenAnswer((_) => Stream.value([noteWithCategory]));

      await tester.pumpWidget(createScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("Notebook"), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.category), findsOneWidget);
      expect(find.byType(NotesList), findsOneWidget);
      expect(find.byType(NoteTile), findsOneWidget);
      expect(find.text(note.title), findsOneWidget);
      expect(find.text(note.description), findsOneWidget);
      expect(find.text(category.name), findsOneWidget);
    });
  });

  group('Test add / edit categories buttons', () {
    testWidgets('clicking add displays add new page', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([]));
      when(databaseService.listNotesInCategory(null, SortOrder.az))
          .thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(createScreen(databaseService));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(EditNoteScreen), findsOneWidget);
      expect(find.text("Add Note"), findsOneWidget);
    });

    testWidgets('clicking categories button displays category screen',
        (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([]));
      when(databaseService.listNotesInCategory(null, SortOrder.az))
          .thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(createScreen(databaseService));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.category));
      await tester.pumpAndSettle();

      expect(find.byType(ListCategoriesScreen), findsOneWidget);
      expect(find.text("Manage Categories"), findsOneWidget);
    });

    // testing of edit / delete handled by the NoteTile widget
  });
}

/// Create the screen for testing
Widget createScreen(DatabaseService db) {
  return ProviderScope(
      overrides: [
        DatabaseService.provider.overrideWithValue(db),
      ],
      child: MaterialApp.router(
        routerConfig: setupRouter(),
      ));
}
