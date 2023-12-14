import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:machine_test_rearrange/rearrange/data/data_sources/app_remote_datasource.dart';
import 'package:machine_test_rearrange/rearrange/data/repositories/app_repository.dart';
import 'package:machine_test_rearrange/rearrange/domain/repositories/app_repository_impl.dart';
import 'package:machine_test_rearrange/rearrange/domain/use_cases/get_categories_use_case.dart';
import 'package:machine_test_rearrange/rearrange/domain/use_cases/get_product_use_case.dart';
import 'package:machine_test_rearrange/rearrange/presentation/utils/sizeclass.dart';

import 'core/api_provider.dart';
import 'core/connection_checker.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  //core
  sl.registerLazySingleton<ApiProvider>(() => ApiProvider());

  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  sl.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(sl()));
  //data source
  sl.registerLazySingleton<AppRemoteDataSource>(
      () => AppRemoteDataSourceImpl(sl()));

  //repository
  sl.registerLazySingleton<AppRepository>(() => AppRepositoryImpl(sl()));

  //use case
  sl.registerLazySingleton<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton<SizeClass>(() => SizeClass());
}
