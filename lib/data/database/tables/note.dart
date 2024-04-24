import 'package:drift/drift.dart';
import 'package:flutter_notebook/data/database/tables/category.dart';

// Table definition for note table
// Need to run 'dart run build_runner build' after making changes to this file
@DataClassName('Note')
class Notes extends Table {
  IntColumn get noteId => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #categoryId)();
  DateTimeColumn get modifiedDate => dateTime()();
}
