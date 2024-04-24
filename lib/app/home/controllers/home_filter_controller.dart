import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_notebook/data/database/sort_order.dart';
import 'package:flutter_notebook/app/category/models/category_model.dart';

final activeCategory = StateProvider<CategoryModel?>((_) => null);
final activeSortOrder = StateProvider<SortOrder?>((_) => SortOrder.az);
