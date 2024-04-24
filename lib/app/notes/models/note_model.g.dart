// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteModelImpl _$$NoteModelImplFromJson(Map<String, dynamic> json) =>
    _$NoteModelImpl(
      noteId: json['noteId'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as int?,
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
    );

Map<String, dynamic> _$$NoteModelImplToJson(_$NoteModelImpl instance) =>
    <String, dynamic>{
      'noteId': instance.noteId,
      'title': instance.title,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
    };
