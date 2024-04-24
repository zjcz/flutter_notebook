import 'package:flutter_notebook/app/category/models/category_model.dart';
import 'package:flutter_notebook/app/notes/models/note_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'note_with_category_model.freezed.dart';
part 'note_with_category_model.g.dart';

@freezed
class NoteWithCategoryModel with _$NoteWithCategoryModel {
  const factory NoteWithCategoryModel(
      {required NoteModel note,
      CategoryModel? category}) = _NoteWithCategoryModel;

  factory NoteWithCategoryModel.fromJson(Map<String, Object?> json) =>
      _$NoteWithCategoryModelFromJson(json);
}
