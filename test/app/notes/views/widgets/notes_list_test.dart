import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_notebook/app/notes/views/widgets/note_tile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_notebook/app/notes/views/widgets/notes_list.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';
import 'package:flutter_notebook/app/notes/models/note_model.dart';
import 'package:flutter_notebook/app/notes/models/note_with_category_model.dart';

void main() {
  group('List View Tile Widget Tests', () {
    testWidgets('Testing Note List View Tile', (tester) async {
      String title = 'New Note Title';
      String desc = 'New Note Description';
      NoteWithCategoryModel n = NoteWithCategoryModel(
          note: NoteModel(
              noteId: 1,
              title: title,
              description: desc,
              categoryId: 1,
              modifiedDate: DateTime.now()),
          category: const CategoryModel(categoryId: 1, name: 'Test Category'));

      await tester.pumpWidget(createList([n], (_) {}, (_) {}));
      await tester.pumpAndSettle();

      expect(find.byType(NotesList), findsOneWidget);
      expect(find.byType(NoteTile), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      expect(find.text(desc), findsOneWidget);
    });

    testWidgets('Testing Note List View Tile for empty list', (tester) async {
      await tester.pumpWidget(createList([], (_) {}, (_) {}));
      await tester.pumpAndSettle();

      expect(find.byType(NotesList), findsOneWidget);
      expect(find.byType(NoteTile), findsNothing);
      expect(find.text('No notes found.  Click + to add one'), findsOneWidget);
    });

    testWidgets('Testing tapping for edit', (tester) async {
      final onEditCompleter = Completer<int>();
      final onDeleteCompleter = Completer<int>();
      String title = 'New Note Title';
      String desc = 'New Note Description';
      CategoryModel category =
          const CategoryModel(categoryId: 1, name: 'Test Category');
      NoteWithCategoryModel n1 = NoteWithCategoryModel(
          note: NoteModel(
              noteId: 1,
              title: title,
              description: desc,
              categoryId: 1,
              modifiedDate: DateTime.now()),
          category: category);
      NoteWithCategoryModel n2 = NoteWithCategoryModel(
          note: NoteModel(
              noteId: 2,
              title: title,
              description: desc,
              categoryId: 1,
              modifiedDate: DateTime.now()),
          category: category);
      NoteWithCategoryModel n3 = NoteWithCategoryModel(
          note: NoteModel(
              noteId: 3,
              title: title,
              description: desc,
              categoryId: 1,
              modifiedDate: DateTime.now()),
          category: category);

      await tester.pumpWidget(createList(
          [n1, n2, n3], onEditCompleter.complete, onDeleteCompleter.complete));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(NoteTile).last);
      await tester.pumpAndSettle();

      expect(onEditCompleter.isCompleted, isTrue);
      expect(onDeleteCompleter.isCompleted, isFalse);

      // check the correct value was passed in the callback
      int toEdit = await onEditCompleter.future;
      expect(toEdit, n3.note.noteId);
    });

    testWidgets('Testing tapping for delete', (tester) async {
      final onEditCompleter = Completer<int>();
      final onDeleteCompleter = Completer<int>();
      String title = 'New Note Title';
      String desc = 'New Note Description';
      CategoryModel category =
          const CategoryModel(categoryId: 1, name: 'Test Category');
      NoteWithCategoryModel n1 = NoteWithCategoryModel(
          note: NoteModel(
              noteId: 1,
              title: title,
              description: desc,
              categoryId: 1,
              modifiedDate: DateTime.now()),
          category: category);
      NoteWithCategoryModel n2 = NoteWithCategoryModel(
          note: NoteModel(
              noteId: 2,
              title: title,
              description: desc,
              categoryId: 1,
              modifiedDate: DateTime.now()),
          category: category);
      NoteWithCategoryModel n3 = NoteWithCategoryModel(
          note: NoteModel(
              noteId: 3,
              title: title,
              description: desc,
              categoryId: 1,
              modifiedDate: DateTime.now()),
          category: category);

      await tester.pumpWidget(createList(
          [n1, n2, n3], onEditCompleter.complete, onDeleteCompleter.complete));
      await tester.pumpAndSettle();

      // first step presses the ... button to display the menu options
      await tester.tap(find.byType(IconButton).last);
      await tester.pumpAndSettle();

      // need second step to select the remove menu item
      await tester.tap(find.widgetWithText(MenuItemButton, 'Remove'));
      await tester.pumpAndSettle();

      expect(onEditCompleter.isCompleted, isFalse);
      expect(onDeleteCompleter.isCompleted, isTrue);

      // check the correct value was passed in the callback
      int toDelete = await onDeleteCompleter.future;
      expect(toDelete, n3.note.noteId);
    });
  });
}

/// Helper function to create the widget under test
Widget createList(List<NoteWithCategoryModel> notes, Function(int) onEdit,
    Function(int) onDelete) {
  return MaterialApp(
      home: Scaffold(
          body: NotesList(
    noteList: notes,
    onDeleteNote: onDelete,
    onEditNote: onEdit,
  )));
}
