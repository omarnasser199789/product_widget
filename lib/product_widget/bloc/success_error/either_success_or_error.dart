import 'package:dartz/dartz.dart';

import 'package:ecapp_core_v2/core/error/failures.dart';
import 'package:ecapp_core_v2/product/domain/entities/pagination_product_entity.dart';
import 'package:ecapp_core_v2/product/domain/entities/product_entity.dart';
import '../home_state.dart';

Stream<HomeState> successGetAllProductsOrErrorState(Either<Failure,PaginationProductEntity> failureOrSuccess) async* {
  yield failureOrSuccess.fold(
        (failure) => Error(message: mapFailureToMessage(failure)),
        (productsEntity) => SuccessGetAllProductsEntity(productsEntity:productsEntity),
  );
}

Stream<HomeState> successGetProductsBySubCatIdOrErrorState(Either<Failure, PaginationProductEntity> failureOrSuccess) async* {
  yield failureOrSuccess.fold(
        (failure) => Error(message: mapFailureToMessage(failure)),
        (productsEntity) => SuccessGetProductsBySubCatIdEntity(productsEntity:productsEntity),
  );
}

Stream<HomeState> successGetProductByIdOrErrorState(Either<Failure, ProductEntity> failureOrSuccess) async* {
  yield failureOrSuccess.fold(
    (failure) => Error(message: mapFailureToMessage(failure)),
    (productEntity) => SuccessGetProductByIdEntity(productEntity:productEntity),
  );
}

Stream<HomeState> successCacheOrErrorState(Either<Failure, ProductEntity> failureOrSuccess) async* {
  yield failureOrSuccess.fold(
    (failure) => Error(message: mapFailureToMessage(failure)),
    (productEntity) => SuccessGetProductByIdEntity(productEntity:productEntity),
  );
}


