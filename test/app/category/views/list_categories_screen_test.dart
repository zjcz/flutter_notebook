import 'package:flutter/material.dart';
import 'package:flutter_notebook/app/category/views/widgets/edit_categories_bottomsheet.dart';
import 'package:flutter_notebook/widgets/delete_confirmation_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_notebook/app/category/views/list_categories_screen.dart';
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'list_categories_screen_test.mocks.dart';

// Test the list category screen
// Note - rather than mocking the provider we mock the database service the
// provider gets its data from, as advised in the Riverpod documentation
// https://riverpod.dev/docs/essentials/testing#mocking-notifiers
@GenerateMocks([DatabaseService])
void main() {
  group('Test displaying the screen', () {
    testWidgets('show the screen with no records', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([]));
      await tester.pumpWidget(createScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("Manage Categories"), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('show the screen with a single category record',
        (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      Category category = Category(categoryId: categoryId, name: categoryName);

      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([category]));

      await tester.pumpWidget(createScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("Manage Categories"), findsOneWidget);
      expect(find.widgetWithText(ListView, categoryName), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });
  });

  group('Test add / edit', () {
    testWidgets('clicking add displays add new control', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(createScreen(databaseService));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text("Add Category"), findsOneWidget);
      expect(find.widgetWithText(EditCategoriesBottomsheet, "Add Category"),
          findsOneWidget);
    });

    testWidgets('clicking edit displays edit control', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      Category category = Category(categoryId: categoryId, name: categoryName);

      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([category]));

      await tester.pumpWidget(createScreen(databaseService));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();

      expect(find.text("Edit Category"), findsOneWidget);
      expect(find.widgetWithText(EditCategoriesBottomsheet, "Edit Category"),
          findsOneWidget);
    });
  });

  group('Test delete', () {
    testWidgets('clicking delete displays the are you sure prompt',
        (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      Category category = Category(categoryId: categoryId, name: categoryName);

      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([category]));

      await tester.pumpWidget(createScreen(databaseService));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      expect(find.text("Remove this Category?"), findsOneWidget);
      expect(
          find.widgetWithText(
              DeleteConfirmationDialog, "Remove this Category?"),
          findsOneWidget);
    });

    testWidgets('clicking delete calls the delete method', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      Category category = Category(categoryId: categoryId, name: categoryName);

      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([category]));
      when(databaseService.deleteCategory(categoryId))
          .thenAnswer((_) => Future.value(categoryId));

      await tester.pumpWidget(createScreen(databaseService));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, "Confirm"));
      await tester.pumpAndSettle();

      verify(databaseService.deleteCategory(categoryId)).called(1);
      expect(
          find.widgetWithText(
              DeleteConfirmationDialog, "Remove this Category?"),
          findsNothing);
    });

    testWidgets('clicking cancel does not call the delete method',
        (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      Category category = Category(categoryId: categoryId, name: categoryName);

      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([category]));
      when(databaseService.deleteCategory(categoryId))
          .thenAnswer((_) => Future.value(categoryId));

      await tester.pumpWidget(createScreen(databaseService));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, "Cancel"));
      await tester.pumpAndSettle();

      verifyNever(databaseService.deleteCategory(categoryId));
      expect(
          find.widgetWithText(
              DeleteConfirmationDialog, "Remove this Category?"),
          findsNothing);
    });
  });
}

/// Create the screen for testing
Widget createScreen(DatabaseService db) {
  return ProviderScope(
    overrides: [
      DatabaseService.provider.overrideWithValue(db),
    ],
    child: const MaterialApp(home: ListCategoriesScreen()),
  );
}
