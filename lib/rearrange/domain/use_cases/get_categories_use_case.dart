import 'package:machine_test_rearrange/core/usecase.dart';
import 'package:machine_test_rearrange/rearrange/data/repositories/app_repository.dart';

class GetCategoriesUseCase extends UseCase<List<String>, NoParams> {
  final AppRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<List<String>> call(NoParams params) {
    return repository.getCategories();
  }
}
