import 'package:machine_test_rearrange/core/api_provider.dart';
import 'package:machine_test_rearrange/rearrange/data/data_sources/app_remote_routes.dart';
import 'package:machine_test_rearrange/rearrange/data/models/product_model.dart';

abstract class AppRemoteDataSource {
  Future<List<String>> getCategories();
  Future<List<ProductModel>> getProducts(String category);
}

class AppRemoteDataSourceImpl extends AppRemoteDataSource {
  final ApiProvider apiProvider;

  AppRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<List<String>> getCategories() async {
    final data = await apiProvider.get(AppRemoteRoutes.categories);
    return List<String>.from(data['data'].map((e) => e));
  }

  @override
  Future<List<ProductModel>> getProducts(String category) async {
    final data = await apiProvider.get("${AppRemoteRoutes.catProd}/$category");
    return List<ProductModel>.from(
        data['products'].map((e) => ProductModel.fromJson(e)));
  }
}
