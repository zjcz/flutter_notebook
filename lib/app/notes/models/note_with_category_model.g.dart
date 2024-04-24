// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_with_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteWithCategoryModelImpl _$$NoteWithCategoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NoteWithCategoryModelImpl(
      note: NoteModel.fromJson(json['note'] as Map<String, dynamic>),
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NoteWithCategoryModelImplToJson(
        _$NoteWithCategoryModelImpl instance) =>
    <String, dynamic>{
      'note': instance.note,
      'category': instance.category,
    };
