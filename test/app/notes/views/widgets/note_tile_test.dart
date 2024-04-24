import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_notebook/app/notes/views/widgets/note_tile.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';
import 'package:flutter_notebook/app/notes/models/note_model.dart';
import 'package:flutter_notebook/app/notes/models/note_with_category_model.dart';
import 'dart:async';

void main() {
  group('List View Tile Widget Tests', () {
    testWidgets('Test Note List View Tile', (tester) async {
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

      await tester.pumpWidget(createTile(n, () {}, () {}));

      expect(find.text(title), findsOneWidget);
      expect(find.text(desc), findsOneWidget);
    });

    testWidgets('Test tapping for edit', (tester) async {
      final onEditCompleter = Completer<void>();
      final onDeleteCompleter = Completer<void>();
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

      await tester.pumpWidget(
          createTile(n, onEditCompleter.complete, onDeleteCompleter.complete));

      await tester.tap(find.byType(NoteTile));
      await tester.pumpAndSettle();

      expect(onEditCompleter.isCompleted, isTrue);
      expect(onDeleteCompleter.isCompleted, isFalse);
    });

    testWidgets('Test tapping for delete', (tester) async {
      final onEditCompleter = Completer<void>();
      final onDeleteCompleter = Completer<void>();
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

      await tester.pumpWidget(
          createTile(n, onEditCompleter.complete, onDeleteCompleter.complete));

      // first step presses the ... button to display the menu options
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // need second step to select the remove menu item
      await tester.tap(find.widgetWithText(MenuItemButton, 'Remove'));
      await tester.pumpAndSettle();

      expect(onEditCompleter.isCompleted, isFalse);
      expect(onDeleteCompleter.isCompleted, isTrue);
    });

    testWidgets('Test long description is trimmed', (tester) async {
      String title = 'New Note Title';
      // description of 200 characters
      String desc = 'x' * 200;

      NoteWithCategoryModel n = NoteWithCategoryModel(
          note: NoteModel(
              noteId: 1,
              title: title,
              description: desc,
              categoryId: 1,
              modifiedDate: DateTime.now()),
          category: const CategoryModel(categoryId: 1, name: 'Test Category'));

      await tester.pumpWidget(createTile(n, () {}, () {}));

      expect(find.text(title), findsOneWidget);
      expect(find.text(desc), findsNothing);
      expect(find.text(desc.substring(0, NoteTile.descriptionPreviewLength)),
          findsOneWidget);
    });
  });
}

/// Create a NoteTile widget for testing
Widget createTile(
    NoteWithCategoryModel note, Function() onEdit, Function() onDelete) {
  NoteTile tile = NoteTile(
    note: note,
    onDeleteCallback: onDelete,
    onEditCallback: onEdit,
  );

  return MaterialApp(
      home: Scaffold(
          body: SingleChildScrollView(
              scrollDirection: Axis.horizontal, child: tile)));
}
