import 'package:flutter_notebook/app/category/models/category_model.dart';
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_notebook/data/mapper/category_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test categories mapper', () {
    testWidgets('map single object', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      Category category = Category(categoryId: categoryId, name: categoryName);

      CategoryModel categoryModel = CategoryMapper.mapToModel(category);

      expect(categoryModel, isNotNull);
      expect(categoryModel.categoryId, categoryId);
      expect(categoryModel.name, categoryName);
    });

    testWidgets('map list object object', (tester) async {
      int categoryId = 5;
      String categoryName = 'new category';
      Category category = Category(categoryId: categoryId, name: categoryName);

      List<CategoryModel> categoryModel =
          CategoryMapper.mapToModelList([category]);

      expect(categoryModel, isNotNull);
      expect(categoryModel.length, 1);
      expect(categoryModel[0].categoryId, categoryId);
      expect(categoryModel[0].name, categoryName);
    });
  });
}
