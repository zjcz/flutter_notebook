import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_notebook/app/category/views/widgets/category_dropdown.dart';
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'category_dropdown_test.mocks.dart';

final _formKey = GlobalKey<FormState>();
const String key = 'category_dropdown';

// Test the category dropdown widget
// Note - rather than mocking the provider we mock the database service the 
// provider gets its data from, as advised in the Riverpod documentation
// https://riverpod.dev/docs/essentials/testing#mocking-notifiers
@GenerateMocks([DatabaseService])
void main() {
  group('Test building dropdown', () {
    testWidgets('show the widget with no category record', (tester) async {
      MockDatabaseService databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(createDropdown(databaseService, null, (_) {}));
      await tester.pumpAndSettle();

      expect(find.text("Category"), findsOneWidget);
      expect(find.byType(CategoryDropdown), findsOneWidget);
      verify(databaseService.listAllCategories()).called(1);
    });

    testWidgets('show the dropdown with category record', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      Category category = Category(categoryId: categoryId, name: categoryName);

      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([category]));

      await tester.pumpWidget(createDropdown(databaseService, null, (_) {}));
      await tester.pumpAndSettle();

      verify(databaseService.listAllCategories()).called(1);
      expect(find.text("Category"), findsOneWidget);
      expect(find.byType(CategoryDropdown), findsOneWidget);
    });

    testWidgets('is the category record selectable', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      Category category = Category(categoryId: categoryId, name: categoryName);
      CategoryModel? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;

      onSelectionChanged(CategoryModel? value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([category]));

      await tester.pumpWidget(
          createDropdown(databaseService, null, onSelectionChanged));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CategoryDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find
          .widgetWithText(DropdownMenuItem<CategoryModel?>, categoryName)
          .last);
      await tester.pump();

      expect(onSelectionChangedValue?.categoryId, equals(categoryId));
      expect(onSelectionChangedCalled, isTrue);
    });

    testWidgets('is the [none] category record selectable', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      String noneCategoryName = '[ - None - ]';
      Category category = Category(categoryId: categoryId, name: categoryName);
      CategoryModel? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;

      onSelectionChanged(CategoryModel? value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([category]));

      await tester.pumpWidget(createDropdown(
          databaseService, null, onSelectionChanged, noneCategoryName));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CategoryDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find
          .widgetWithText(DropdownMenuItem<CategoryModel?>, noneCategoryName)
          .last);
      await tester.pump();

      expect(onSelectionChangedValue, isNull);
      expect(onSelectionChangedCalled, isTrue);
    });

    testWidgets('specified category is pre selected', (tester) async {
      int categoryId1 = 1;
      String categoryName1 = 'new category one';
      Category category1 =
          Category(categoryId: categoryId1, name: categoryName1);
      int categoryId2 = 2;
      String categoryName2 = 'new category two';
      Category category2 =
          Category(categoryId: categoryId2, name: categoryName2);
      int categoryId3 = 3;
      String categoryName3 = 'new category three';
      Category category3 =
          Category(categoryId: categoryId3, name: categoryName3);
      int selectedCategoryId = 2;

      onSelectionChanged(CategoryModel? value) {}

      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([category1, category2, category3]));

      await tester.pumpWidget(createDropdown(
          databaseService, selectedCategoryId, onSelectionChanged));
      await tester.pumpAndSettle();

      expect(find.text(categoryName1), findsNothing);
      expect(find.text(categoryName2), findsOneWidget);
      expect(find.text(categoryName3), findsNothing);
      verify(databaseService.listAllCategories()).called(1);
    });
  });
}

/// Create the widget for testing
Widget createDropdown(
    DatabaseService db, int? categoryId, Function(CategoryModel?) onChanged,
    [String noneNodeText = '(none)']) {
  return ProviderScope(
    overrides: [
      DatabaseService.provider.overrideWithValue(db),
    ],
    child: MaterialApp(
        home: Scaffold(
            body: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: CategoryDropdown(
                    key: const Key(key),
                    categoryId: categoryId,
                    onChanged: onChanged,
                    noneNodeText: noneNodeText)))),
  );
}
