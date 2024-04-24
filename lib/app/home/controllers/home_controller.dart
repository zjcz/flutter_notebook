import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_notebook/data/database/sort_order.dart';
import 'package:flutter_notebook/app/notes/models/note_with_category_model.dart';
import 'package:flutter_notebook/data/mapper/note_with_category_mapper.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  late final DatabaseService _databaseService =
      ref.read(DatabaseService.provider);

  @override
  Stream<List<NoteWithCategoryModel>> build(
      int? categoryId, SortOrder sortOrder) {
    return _databaseService.listNotesInCategory(categoryId, sortOrder).map(
        (noteWithCategory) =>
            NoteWithCategoryMapper.mapToModelList(noteWithCategory));
  }
}
