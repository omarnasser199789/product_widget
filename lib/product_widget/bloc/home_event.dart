import 'package:ecapp_core_v2/product/domain/entities/pagination_product_entity.dart';
import 'package:ecapp_core_v2/product/domain/use_case/get/get_products_use_case.dart';

abstract class HomeEvent {}

class GetMapItemsEvent extends HomeEvent {}

class GetNewestProductsEvent extends HomeEvent {}

class GetAllProductsEvent extends HomeEvent {
  GetProductsParams params;
  GetAllProductsEvent({required this.params});
}

// class CachingProductsEvent extends HomeEvent {
//   PaginationProductEntity productsEntity;
//   CachingProductsEvent({required this.productsEntity});
// }



