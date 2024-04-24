import 'package:flutter/material.dart';
import 'package:flutter_notebook/data/database/sort_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_notebook/app/home/controllers/home_controller.dart';
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_controller_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test home controller', () {
    testWidgets('get the records', (tester) async {
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
      when(databaseService.listNotesInCategory(null, SortOrder.az))
          .thenAnswer((_) => Stream.value([noteWithCategory]));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final dataList = await container
          .read(homeControllerProvider(null, SortOrder.az).future);

      expect(dataList, isNotNull);
      expect(dataList.length, 1);
      expect(dataList[0].note, isNotNull);
      expect(dataList[0].note.noteId, noteId);
      expect(dataList[0].note.title, title);
      expect(dataList[0].note.description, description);
      expect(dataList[0].note.categoryId, noteCategoryId);
      expect(dataList[0].note.modifiedDate, modifiedDate);
      expect(dataList[0].category, isNotNull);
      expect(dataList[0].category!.categoryId, categoryId);
      expect(dataList[0].category!.name, categoryName);

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
