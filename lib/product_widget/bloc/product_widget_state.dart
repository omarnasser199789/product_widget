
import 'package:ecapp_core_v2/product/domain/entities/pagination_product_entity.dart';

abstract class ProductWidgetState {}

class PatientsInitial extends ProductWidgetState {}

class Loading extends ProductWidgetState {}


///Products Section
///
class SuccessGetAllProductsEntity extends ProductWidgetState {
  PaginationProductEntity productsEntity;
  SuccessGetAllProductsEntity({required this.productsEntity});
}

// class SuccessGetProductsBySubCatIdEntity extends ProductWidgetState {
//   PaginationProductEntity productsEntity;
//   SuccessGetProductsBySubCatIdEntity({required this.productsEntity});
// }

// class SuccessGetProductByIdEntity extends ProductWidgetState {
//   ProductEntity productEntity;
//   SuccessGetProductByIdEntity({required this.productEntity});
// }
//
// class SuccessCacheVideos extends ProductWidgetState {
//   PaginationProductEntity productsEntity;
//   SuccessCacheVideos({required this.productsEntity});
// }


class Error extends  ProductWidgetState {
  final String message;

  Error({ required this.message}); //we use this constructor in ((BLOC & test))

  @override
  List<Object> get props => [message];
}

class Empty extends  ProductWidgetState {}
