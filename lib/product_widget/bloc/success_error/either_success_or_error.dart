import 'package:dartz/dartz.dart';
import 'package:ecapp_core/banner/domain/entities/pagination_banner_entity.dart';
import 'package:ecapp_core/category/domain/entities/category_entity.dart';
import 'package:ecapp_core/category/domain/entities/pagination_category_entity.dart';
import 'package:ecapp_core/core/error/failures.dart';
import 'package:ecapp_core/product/domain/entities/pagination_product_entity.dart';
import 'package:ecapp_core/product/domain/entities/product_entity.dart';
import '../home_state.dart';

///Categories Section
///
Stream<HomeState> SuccessGetParentCategoriesOrErrorState(Either<Failure, PaginationCategoryEntity> failureOrSuccess,) async* {
  yield failureOrSuccess.fold(
        (failure) => Error(message: mapFailureToMessage(failure)),
        (entity) => SuccessGetParentCategories(categoriesEntity:entity),
  );
}

Stream<HomeState> SuccessGetCategoriesByParentIdOrErrorState(Either<Failure, List<CategoryEntity>> failureOrSuccess) async* {
  yield failureOrSuccess.fold(
        (failure) => Error(message: mapFailureToMessage(failure)),
        (list) => SuccessGetCategoriesByParentId(list:list),
  );
}

///Banners Section
///
Stream<HomeState> SuccessGetBannersOrErrorState(Either<Failure, PaginationBannersEntity> failureOrSuccess) async* {
  yield failureOrSuccess.fold(
    (failure) => Error(message: mapFailureToMessage(failure)),
    (bannersEntity) => SuccessGetBanners(bannersEntity:bannersEntity),
  );
}

///Products Section
///
Stream<HomeState> SuccessGetAllProductsOrErrorState(Either<Failure,PaginationProductEntity> failureOrSuccess) async* {
  yield failureOrSuccess.fold(
        (failure) => Error(message: mapFailureToMessage(failure)),
        (productsEntity) => SuccessGetAllProductsEntity(productsEntity:productsEntity),
  );
}

Stream<HomeState> SuccessGetProductsBySubCatIdOrErrorState(Either<Failure, PaginationProductEntity> failureOrSuccess) async* {
  yield failureOrSuccess.fold(
        (failure) => Error(message: mapFailureToMessage(failure)),
        (productsEntity) => SuccessGetProductsBySubCatIdEntity(productsEntity:productsEntity),
  );
}

Stream<HomeState> SuccessGetProductByIdOrErrorState(Either<Failure, ProductEntity> failureOrSuccess) async* {
  yield failureOrSuccess.fold(
    (failure) => Error(message: mapFailureToMessage(failure)),
    (productEntity) => SuccessGetProductByIdEntity(productEntity:productEntity),
  );
}

Stream<HomeState> SuccessCacheOrErrorState(Either<Failure, ProductEntity> failureOrSuccess) async* {
  yield failureOrSuccess.fold(
    (failure) => Error(message: mapFailureToMessage(failure)),
    (productEntity) => SuccessGetProductByIdEntity(productEntity:productEntity),
  );
}


