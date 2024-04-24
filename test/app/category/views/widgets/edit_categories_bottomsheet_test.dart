import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_notebook/app/category/views/widgets/edit_categories_bottomsheet.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';

import 'dart:async';


void main() {
  group('Edit Category Bottomsheet Widget Tests', () {
    testWidgets('Testing Add New Dialog Text', (tester) async {
      await tester.pumpWidget(createWidget(null, (_) {}));

      expect(find.text("Add Category"), findsOneWidget);
      expect(find.text("Category Name"), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('Testing Edit Existing Dialog Text', (tester) async {
      CategoryModel category = const CategoryModel(categoryId: 1, name: 'Test Category');
      await tester.pumpWidget(createWidget(category, (_) {}));

      expect(find.text("Edit Category"), findsOneWidget);
      expect(find.text("Category Name"), findsOneWidget);
      expect(find.text(category.name), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('Testing cancel removes widget', (tester) async {
      final completer = Completer<CategoryModel>();
      await tester.pumpWidget(createWidget(null, completer.complete));

      expect(find.text("Add Category"), findsOneWidget);
      expect(find.text("Category Name"), findsOneWidget);

      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();

      expect(find.text("Add Category"), findsNothing);
      expect(find.text("Category Name"), findsNothing);
      expect(completer.isCompleted, isFalse);
    });

    testWidgets('Testing save widget for new valid category', (tester) async {
      bool saved = false;
      CategoryModel? savedCategory;
      String newCategoryName = 'New Category';
      onSave(CategoryModel category) {
        saved = true;
        savedCategory = category;
      }

      await tester.pumpWidget(createWidget(null, onSave));
      await tester.enterText(
          find.bySemanticsLabel('Category Name'), newCategoryName);
      await tester.tap(find.byIcon(Icons.check_circle));
      await tester.pumpAndSettle();

      expect(saved, isTrue);
      expect(savedCategory, isNotNull);
      expect(savedCategory!.categoryId, isNull);
      expect(savedCategory!.name, newCategoryName);
    });

    testWidgets('Testing save widget for editing valid category',
        (tester) async {
      CategoryModel category = const CategoryModel(categoryId: 1, name: 'Test Category');
      bool saved = false;
      CategoryModel? savedCategory;
      String newCategoryName = 'New Category';
      onSave(CategoryModel category) {
        saved = true;
        savedCategory = category;
      }

      await tester.pumpWidget(createWidget(category, onSave));
      await tester.enterText(
          find.bySemanticsLabel('Category Name'), newCategoryName);
      await tester.tap(find.byIcon(Icons.check_circle));
      await tester.pumpAndSettle();

      expect(saved, isTrue);
      expect(savedCategory, isNotNull);
      expect(savedCategory!.categoryId, category.categoryId);
      expect(savedCategory!.name, newCategoryName);
    });

    testWidgets('Testing validating widget for new category', (tester) async {
      bool saved = false;
      CategoryModel? savedCategory;
      onSave(CategoryModel category) {
        saved = true;
        savedCategory = category;
      }

      await tester.pumpWidget(createWidget(null, onSave));
      await tester.tap(find.byIcon(Icons.check_circle));
      await tester.pumpAndSettle();

      expect(saved, isFalse);
      expect(savedCategory, isNull);
      expect(find.text("Please enter some text"), findsOneWidget);
    });

    testWidgets('Testing validating widget for editing category',
        (tester) async {
      CategoryModel category = const CategoryModel(categoryId: 1, name: 'Test Category');
      bool saved = false;
      CategoryModel? savedCategory;
      String newCategoryName = '';
      onSave(CategoryModel category) {
        saved = true;
        savedCategory = category;
      }

      await tester.pumpWidget(createWidget(category, onSave));
      await tester.enterText(
          find.bySemanticsLabel('Category Name'), newCategoryName);
      await tester.tap(find.byIcon(Icons.check_circle));
      await tester.pumpAndSettle();

      expect(saved, isFalse);
      expect(savedCategory, isNull);
      expect(find.text("Please enter some text"), findsOneWidget);
    });
  });
}

/// Helper function to create the widget to test with
Widget createWidget(CategoryModel? category, Function(CategoryModel) onSave) {
  return MaterialApp(
      home: Scaffold(
          body: EditCategoriesBottomsheet(category: category, onSave: onSave)));
}