// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_with_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NoteWithCategoryModel _$NoteWithCategoryModelFromJson(
    Map<String, dynamic> json) {
  return _NoteWithCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$NoteWithCategoryModel {
  NoteModel get note => throw _privateConstructorUsedError;
  CategoryModel? get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoteWithCategoryModelCopyWith<NoteWithCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteWithCategoryModelCopyWith<$Res> {
  factory $NoteWithCategoryModelCopyWith(NoteWithCategoryModel value,
          $Res Function(NoteWithCategoryModel) then) =
      _$NoteWithCategoryModelCopyWithImpl<$Res, NoteWithCategoryModel>;
  @useResult
  $Res call({NoteModel note, CategoryModel? category});

  $NoteModelCopyWith<$Res> get note;
  $CategoryModelCopyWith<$Res>? get category;
}

/// @nodoc
class _$NoteWithCategoryModelCopyWithImpl<$Res,
        $Val extends NoteWithCategoryModel>
    implements $NoteWithCategoryModelCopyWith<$Res> {
  _$NoteWithCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? note = null,
    Object? category = freezed,
  }) {
    return _then(_value.copyWith(
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as NoteModel,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CategoryModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NoteModelCopyWith<$Res> get note {
    return $NoteModelCopyWith<$Res>(_value.note, (value) {
      return _then(_value.copyWith(note: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CategoryModelCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryModelCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NoteWithCategoryModelImplCopyWith<$Res>
    implements $NoteWithCategoryModelCopyWith<$Res> {
  factory _$$NoteWithCategoryModelImplCopyWith(
          _$NoteWithCategoryModelImpl value,
          $Res Function(_$NoteWithCategoryModelImpl) then) =
      __$$NoteWithCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({NoteModel note, CategoryModel? category});

  @override
  $NoteModelCopyWith<$Res> get note;
  @override
  $CategoryModelCopyWith<$Res>? get category;
}

/// @nodoc
class __$$NoteWithCategoryModelImplCopyWithImpl<$Res>
    extends _$NoteWithCategoryModelCopyWithImpl<$Res,
        _$NoteWithCategoryModelImpl>
    implements _$$NoteWithCategoryModelImplCopyWith<$Res> {
  __$$NoteWithCategoryModelImplCopyWithImpl(_$NoteWithCategoryModelImpl _value,
      $Res Function(_$NoteWithCategoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? note = null,
    Object? category = freezed,
  }) {
    return _then(_$NoteWithCategoryModelImpl(
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as NoteModel,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CategoryModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoteWithCategoryModelImpl
    with DiagnosticableTreeMixin
    implements _NoteWithCategoryModel {
  const _$NoteWithCategoryModelImpl({required this.note, this.category});

  factory _$NoteWithCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteWithCategoryModelImplFromJson(json);

  @override
  final NoteModel note;
  @override
  final CategoryModel? category;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NoteWithCategoryModel(note: $note, category: $category)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NoteWithCategoryModel'))
      ..add(DiagnosticsProperty('note', note))
      ..add(DiagnosticsProperty('category', category));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteWithCategoryModelImpl &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, note, category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteWithCategoryModelImplCopyWith<_$NoteWithCategoryModelImpl>
      get copyWith => __$$NoteWithCategoryModelImplCopyWithImpl<
          _$NoteWithCategoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteWithCategoryModelImplToJson(
      this,
    );
  }
}

abstract class _NoteWithCategoryModel implements NoteWithCategoryModel {
  const factory _NoteWithCategoryModel(
      {required final NoteModel note,
      final CategoryModel? category}) = _$NoteWithCategoryModelImpl;

  factory _NoteWithCategoryModel.fromJson(Map<String, dynamic> json) =
      _$NoteWithCategoryModelImpl.fromJson;

  @override
  NoteModel get note;
  @override
  CategoryModel? get category;
  @override
  @JsonKey(ignore: true)
  _$$NoteWithCategoryModelImplCopyWith<_$NoteWithCategoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
