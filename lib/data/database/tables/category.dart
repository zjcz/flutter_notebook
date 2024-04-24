import 'package:drift/drift.dart';

// Table definition for category table
// Need to run 'dart run build_runner build' after making changes to this file
@DataClassName('Category')
class Categories extends Table {
  IntColumn get categoryId => integer().autoIncrement()();
  TextColumn get name => text()();
}
