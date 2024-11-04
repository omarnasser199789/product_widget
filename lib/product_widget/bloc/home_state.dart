
import 'package:ecapp_core_v2/product/domain/entities/pagination_product_entity.dart';
import 'package:ecapp_core_v2/product/domain/entities/product_entity.dart';

abstract class HomeState {}

class PatientsInitial extends HomeState {}

class Loading extends HomeState {}


///Products Section
///
class SuccessGetAllProductsEntity extends HomeState {
  PaginationProductEntity productsEntity;
  SuccessGetAllProductsEntity({required this.productsEntity});
}

class SuccessGetProductsBySubCatIdEntity extends HomeState {
  PaginationProductEntity productsEntity;
  SuccessGetProductsBySubCatIdEntity({required this.productsEntity});
}

class SuccessGetProductByIdEntity extends HomeState {
  ProductEntity productEntity;
  SuccessGetProductByIdEntity({required this.productEntity});
}

class SuccessCacheVideos extends HomeState {
  PaginationProductEntity productsEntity;
  SuccessCacheVideos({required this.productsEntity});
}


class Error extends  HomeState {
  final String message;

  Error({ required this.message}); //we use this constructor in ((BLOC & test))

  @override
  List<Object> get props => [message];
}

class Empty extends  HomeState {}
