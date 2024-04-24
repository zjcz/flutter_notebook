import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_notebook/app/category/controllers/categories_controller.dart';
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_controller_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test categories controller', () {
    testWidgets('get the records', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      Category category = Category(categoryId: categoryId, name: categoryName);

      final databaseService = MockDatabaseService();
      when(databaseService.listAllCategories())
          .thenAnswer((_) => Stream.value([category]));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final categoryList =
          await container.read(categoriesControllerProvider.future);

      expect(categoryList, isNotNull);
      expect(categoryList.length, 1);
      expect(categoryList[0].categoryId, categoryId);
      expect(categoryList[0].name, categoryName);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('save new record', (tester) async {
      int newCategoryId = 5;
      int? categoryId;
      String categoryName = 'new category';

      final databaseService = MockDatabaseService();
      when(databaseService.saveCategory(id: categoryId, name: categoryName))
          .thenAnswer((_) => Future.value(newCategoryId));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(categoriesControllerProvider.notifier);
      int savedCategoryId = await provider.saveCategory(
          categoryId: categoryId, name: categoryName);

      verify(databaseService.saveCategory(id: categoryId, name: categoryName))
          .called(1);
      expect(savedCategoryId, newCategoryId);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('save existing record', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';

      final databaseService = MockDatabaseService();
      when(databaseService.saveCategory(id: categoryId, name: categoryName))
          .thenAnswer((_) => Future.value(categoryId));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(categoriesControllerProvider.notifier);
      int savedCategoryId = await provider.saveCategory(
          categoryId: categoryId, name: categoryName);

      verify(databaseService.saveCategory(id: categoryId, name: categoryName))
          .called(1);
      expect(savedCategoryId, categoryId);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('delete record', (tester) async {
      int categoryId = 5;

      final databaseService = MockDatabaseService();
      when(databaseService.deleteCategory(categoryId))
          .thenAnswer((_) => Future.value(categoryId));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(categoriesControllerProvider.notifier);
      int deletedCategoryId =
          await provider.deleteCategory(categoryId: categoryId);

      verify(databaseService.deleteCategory(categoryId)).called(1);
      expect(deletedCategoryId, categoryId);

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
