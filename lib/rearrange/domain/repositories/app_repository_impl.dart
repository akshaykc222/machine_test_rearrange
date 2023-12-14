import 'package:machine_test_rearrange/rearrange/data/data_sources/app_remote_datasource.dart';
import 'package:machine_test_rearrange/rearrange/data/models/product_model.dart';
import 'package:machine_test_rearrange/rearrange/data/repositories/app_repository.dart';

class AppRepositoryImpl extends AppRepository {
  final AppRemoteDataSource dataSource;

  AppRepositoryImpl(this.dataSource);

  @override
  Future<List<String>> getCategories() {
    return dataSource.getCategories();
  }

  @override
  Future<List<ProductModel>> getProducts(String category) {
    return dataSource.getProducts(category);
  }
}
