import 'package:machine_test_rearrange/core/usecase.dart';
import 'package:machine_test_rearrange/rearrange/data/models/product_model.dart';

import '../../data/repositories/app_repository.dart';

class GetProductsUseCase extends UseCase<List<ProductModel>, String> {
  final AppRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<List<ProductModel>> call(String params) {
    return repository.getProducts(params);
  }
}
