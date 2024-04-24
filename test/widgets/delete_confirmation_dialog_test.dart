import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_notebook/widgets/delete_confirmation_dialog.dart';
import 'dart:async';

Widget createDialog(String title, String content, Function onClick) {
  return MaterialApp(
      home: Scaffold(
    body: DeleteConfirmationDialog(
      onConfirmDelete: onClick,
      title: title,
      content: content,
    ),
  ));
}

Widget createDialogWithDefaults(Function onClick) {
  return MaterialApp(
      home: Scaffold(
    body: DeleteConfirmationDialog(
      onConfirmDelete: onClick,
    ),
  ));
}

void main() {
  group('Delete Confirmation Dialog Widget Tests', () {
    testWidgets('Testing Dialog Text', (tester) async {
      String title = 'Dialog Title';
      String content = 'Dialog Content';

      await tester.pumpWidget(createDialog(title, content, () {}));

      expect(find.text(title), findsOneWidget);
      expect(find.text(content), findsOneWidget);
    });

    testWidgets('Testing Dialog confirm', (tester) async {
      String title = 'Dialog Title';
      String content = 'Dialog Content';
      final completer = Completer<void>();

      await tester.pumpWidget(createDialog(title, content, completer.complete));

      expect(find.text(title), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(completer.isCompleted, isTrue);
      expect(find.text(title), findsNothing);
    });

    testWidgets('Testing Dialog cancel', (tester) async {
      String title = 'Dialog Title';
      String content = 'Dialog Content';
      final completer = Completer<void>();

      await tester.pumpWidget(createDialog(title, content, completer.complete));

      expect(find.text(title), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(completer.isCompleted, isFalse);
      expect(find.text(title), findsNothing);
    });

    testWidgets('Testing Dialog Text with default values', (tester) async {
      await tester.pumpWidget(createDialogWithDefaults(() {}));

      expect(find.text('Remove this Item?'), findsOneWidget);
      expect(find.text('Are you sure you want to remove this item?'), findsOneWidget);
    });
  });
}
