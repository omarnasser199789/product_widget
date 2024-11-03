import 'package:ecapp_core/auth/data/data_sources/remot_data_sourse/auth_data_source.dart';
import 'package:ecapp_core/auth/data/repositories/auth_repository_impl.dart';
import 'package:ecapp_core/auth/domain/repositories/auth_repository.dart';
import 'package:ecapp_core/auth/domain/use_cases/create_new_user.dart';
import 'package:ecapp_core/auth/domain/use_cases/login_anonymously.dart';
import 'package:ecapp_core/auth/domain/use_cases/mobile_login_use_case.dart';
import 'package:ecapp_core/auth/domain/use_cases/register_user_in_firebase_usecase.dart';
import 'package:ecapp_core/auth/domain/use_cases/send_otp_use_case.dart';
import 'package:ecapp_core/banner/data/data_source/remote_data_source/banner_remote_data_source.dart';
import 'package:ecapp_core/banner/data/repositories/banner_repository_impl.dart';
import 'package:ecapp_core/banner/domain/repositories/banner_repository.dart';
import 'package:ecapp_core/banner/domain/use_case/get_banners_use_case.dart';
import 'package:ecapp_core/category/data/data_source/remote_data_source/category_remote_data_source.dart';
import 'package:ecapp_core/category/data/repositories/category_repository_impl.dart';
import 'package:ecapp_core/category/domain/repositories/category_repository.dart';
import 'package:ecapp_core/category/domain/use_case/get_all_categories_use_case.dart';
import 'package:ecapp_core/category/domain/use_case/get_categories_by_parent_id_use_case.dart';
import 'package:ecapp_core/category/domain/use_case/get_parent_categories_use_case.dart';
import 'package:ecapp_core/product/data/data_source/remote_data_source/product_remote_data_source.dart';
import 'package:ecapp_core/product/data/repositories/product_repository_impl.dart';
import 'package:ecapp_core/product/domain/repositories/product_repository.dart';
import 'package:ecapp_core/product/domain/use_case/create_new_product_use_case.dart';
// import 'package:ecapp_core/product/domain/use_case/get_all_products_use_case.dart';
// import 'package:ecapp_core/product/domain/use_case/get_product_by_id_use_case.dart';
// import 'package:ecapp_core/product/domain/use_case/get_products_by_cat_id_use_case.dart';
import 'package:ecapp_core/product_attachment/data/data_sources/remote_data_source/products_attachments_data_source.dart';
import 'package:ecapp_core/product_attachment/data/repositories/products_attachments_repository_impl.dart';
import 'package:ecapp_core/product_attachment/domain/repositories/products_attachments_repository.dart';
import 'package:ecapp_core/product_attachment/domain/use_cases/get_videos_use_case.dart';
import 'package:ecapp_core/product_attachment/product_attachment.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:product_widget/product_widget/bloc/home_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'core/globals.dart';
// import 'core/managers/device_info_manager.dart';
// import 'features/adding/presentation/bloc/adding_bloc.dart';
// import 'features/home/presentation/bloc/home_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final sl = GetIt.instance;

Future<void> init() async {
  ///Bloc
  sl.registerFactory(
    () => HomeBloc(
      // concreteGetBannersUseCase: sl(),
      concreteGetCategoriesByParentIdUseCase: sl(),
      concreteGetProductsByCatIdUseCase: sl(),
      concreteGetParentCategoriesUseCase: sl(),
      concreteGetProductByIdUseCase: sl(),
      // concreteGetAllProductsUseCase: sl(),
      concreteGetAllCategoriesUseCase: sl(),
      concreteGetLiteBannersUseCase: sl(),
      concreteGetLiteProductsUseCase: sl(),
    )
  );


  ///Use cases
  // sl.registerLazySingleton(() => GetAllProductsUseCase(repository: sl()));
  // sl.registerLazySingleton(() => GetProductByIdUseCase(repository: sl()));
  // sl.registerLazySingleton(() => GetProductsByCatIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoriesByParentIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllCategoriesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetBannersUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetParentCategoriesUseCase(repository: sl()));
  //
  sl.registerLazySingleton(() => GetVideosUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUserInFirebaseUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateNewUserUseCase(repository: sl()));
  sl.registerLazySingleton(() => MobileLoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginAnonymouslyUseCase(repository: sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateNewProductUseCase(repository: sl()));


  ///Repository

  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(productRemoteDataSource: sl()));
  sl.registerLazySingleton<ProductsAttachmentsRepository>(() => ProductsAttachmentsRepositoryImpl(productsAttachmentsRemoteDataSource: sl()));
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(categoryRemoteDataSource: sl()));
  sl.registerLazySingleton<BannerRepository>(() => BannerRepositoryImpl(bannerRemoteDataSource: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authRemoteDataSource: sl()));



  ///Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl( client: sl()));
  sl.registerLazySingleton<ProductsAttachmentsRemoteDataSource>(() => ProductsAttachmentsRemoteDataSourceImpl( client: sl()));
  sl.registerLazySingleton<CategoryRemoteDataSource>(() => CategoryRemoteDataSourceImpl( client: sl()));
  sl.registerLazySingleton<BannerRemoteDataSource>(() => BannerRemoteDataSourceImpl( client: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl( client: sl()));


  /// External
  // database = openDatabase(
  //   /**
  //    * ? Set the path to the database. Note: Using the `join` function from the
  //    * ? `path` package is best practice to ensure the path is correctly
  //    * ? constructed for each platform.
  //    */
  //   join(await getDatabasesPath(), 'database.db'),
  //   onCreate: (db, version) {
  //     ///Create cart table
  //     return db.execute(
  //       'CREATE TABLE wishlist(id INTEGER PRIMARY KEY,apiID INTEGER unique, title TEXT,image TEXT)',
  //     );
  //
  //   },
  //   /**
  //    * ? Set the version. This executes the onCreate function and provides a
  //    * ? path to perform database upgrades and downgrades.
  //    */
  //   version: 3,
  // );
  // globalSH = await SharedPreferences.getInstance();

  // sl.registerLazySingleton(() => globalSH);
  sl.registerLazySingleton(() => http.Client());
  /// Register DeviceInfoManager as a singleton
  // sl.registerLazySingleton(() => DeviceInfoManager());

}
