import 'package:dartz/dartz.dart';
import 'package:ecapp_core_v2/core/error/failures.dart';
import 'package:ecapp_core_v2/product/domain/entities/pagination_product_entity.dart';
import '../product_widget_state.dart';

Stream<ProductWidgetState> successGetAllProductsOrErrorState(Either<Failure,PaginationProductEntity> failureOrSuccess) async* {
  yield failureOrSuccess.fold(
        (failure) => Error(message: mapFailureToMessage(failure)),
        (productsEntity) => SuccessGetAllProductsEntity(productsEntity:productsEntity),
  );
}
