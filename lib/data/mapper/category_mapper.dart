import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';

class CategoryMapper {
  static CategoryModel mapToModel(Category category) {
    return CategoryModel(
      categoryId: category.categoryId,
      name: category.name,
    );
  }

  static List<CategoryModel> mapToModelList(List<Category> categories) {
    return categories.map((category) => mapToModel(category)).toList();
  }
}
