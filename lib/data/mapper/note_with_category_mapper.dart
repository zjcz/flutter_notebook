import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_notebook/data/mapper/note_mapper.dart';
import 'package:flutter_notebook/data/mapper/category_mapper.dart';
import 'package:flutter_notebook/app/notes/models/note_with_category_model.dart';

class NoteWithCategoryMapper {
  static NoteWithCategoryModel mapToModel(NoteWithCategory noteWithCategory) {
    return NoteWithCategoryModel(
      note: NoteMapper.mapToModel(noteWithCategory.note),
      category: noteWithCategory.category != null
          ? CategoryMapper.mapToModel(noteWithCategory.category!)
          : null,
    );
  }

  static List<NoteWithCategoryModel> mapToModelList(
      List<NoteWithCategory> noteWithCategories) {
    return noteWithCategories
        .map((noteWithCategory) => mapToModel(noteWithCategory))
        .toList();
  }
}
