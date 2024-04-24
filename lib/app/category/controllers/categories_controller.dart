import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';
import 'package:flutter_notebook/data/mapper/category_mapper.dart';

part 'categories_controller.g.dart';

@riverpod
class CategoriesController extends _$CategoriesController {
  late final DatabaseService _databaseService =
      ref.read(DatabaseService.provider);

  @override
  Stream<List<CategoryModel>> build() {
    return _databaseService
        .listAllCategories()
        .map((category) => CategoryMapper.mapToModelList(category));
  }

  Future<int> saveCategory(
      {required int? categoryId, required String name}) async {
    return _databaseService.saveCategory(
      id: categoryId,
      name: name,
    );
  }

  Future<int> deleteCategory({required int categoryId}) async {
    return _databaseService.deleteCategory(categoryId);
  }
}
