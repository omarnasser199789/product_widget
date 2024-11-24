import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:product_widget/product_widget/bloc/product_widget_bloc.dart';
import 'package:ecapp_core_v2/product/domain/use_case/get/get_products_use_case.dart';
import 'package:ecapp_core_v2/product/domain/repositories/product_repository.dart';
import 'package:ecapp_core_v2/product/data/repositories/product_repository_impl.dart';
import 'package:ecapp_core_v2/product/data/data_source/remote_data_source/product_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  ///Bloc
  sl.registerFactory(
    () => ProductWidgetBloc(
      concreteGetProductsUseCase: sl(),
    )
  );


  ///Use cases
  sl.registerLazySingleton(() => GetProductsUseCase(repository: sl()));


  ///Repository
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(productRemoteDataSource: sl()));


  ///Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl( client: sl()));


  sl.registerLazySingleton(() => http.Client());
  /// Register DeviceInfoManager as a singleton
  // sl.registerLazySingleton(() => DeviceInfoManager());

}
