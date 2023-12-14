import '../models/product_model.dart';

abstract class AppRepository {
  Future<List<String>> getCategories();
  Future<List<ProductModel>> getProducts(String category);
}
