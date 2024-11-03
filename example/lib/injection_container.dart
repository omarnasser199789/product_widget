import 'package:ecapp_core/product/data/data_source/remote_data_source/product_remote_data_source.dart';
import 'package:ecapp_core/product/data/repositories/product_repository_impl.dart';
import 'package:ecapp_core/product/domain/repositories/product_repository.dart';
import 'package:ecapp_core/product/domain/use_case/get/get_lite_products_use_case.dart';
import 'package:ecapp_core/product/domain/use_case/get/get_products_by_cat_id_use_case.dart';
import 'package:ecapp_core/product/domain/use_case/get/get_product_by_id_use_case.dart';




import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:product_widget/product_widget/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  ///Bloc
  sl.registerFactory(
    () => HomeBloc(

      concreteGetLiteProductsUseCase: sl(),
      concreteGetProductsByCatIdUseCase: sl(),
      concreteGetProductByIdUseCase: sl(),
    )
  );


  ///Use cases
  sl.registerLazySingleton(() => GetLiteProductsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetProductsByCatIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(repository: sl()));



  ///Repository

  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(productRemoteDataSource: sl()));


  ///Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl( client: sl()));


  sl.registerLazySingleton(() => http.Client());
  /// Register DeviceInfoManager as a singleton
  // sl.registerLazySingleton(() => DeviceInfoManager());

}
