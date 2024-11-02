
import 'package:ecapp_core/banner/domain/use_case/get_light_banners_use_case.dart';
import 'package:ecapp_core/category/domain/use_case/get_all_categories_use_case.dart';
import 'package:ecapp_core/product/domain/entities/pagination_product_entity.dart';
import 'package:ecapp_core/product/domain/use_case/get/get_lite_products_use_case.dart';

abstract class HomeEvent {}

class GetBannersEvent extends HomeEvent {
  GetLiteBannersParams params;
  GetBannersEvent({required this.params});
}

class GetParentCategoriesEvent extends HomeEvent {}

class GetMapItemsEvent extends HomeEvent {}

class GetNewestProductsEvent extends HomeEvent {}

class GetAllProductsEvent extends HomeEvent {
  GetLiteProductsParams params;
  GetAllProductsEvent({required this.params});
}
class CachingProductsEvent extends HomeEvent {
  PaginationProductEntity productsEntity;
  CachingProductsEvent({required this.productsEntity});
}

class GetPlaceEvent extends HomeEvent {
  int id;
  GetPlaceEvent({required this.id});
}

class GetTagsEvent extends HomeEvent {
  int ? catId;
  GetTagsEvent({required this.catId});
}

class GetCategoriesByParentIdEvent extends HomeEvent {
  GetCategoriesByParentIdEvent({required this.id});
  int  id;
}

class GetAllCategoriesEvent extends HomeEvent {
  GetAllCategoriesParams params;
  GetAllCategoriesEvent({
    required this.params
});
}

class GetProductsByCatIdEvent extends HomeEvent {
  GetProductsByCatIdEvent({required this.id});
  int  id;
}

class GetProductByIdEvent extends HomeEvent {
  GetProductByIdEvent({required this.id});
  int  id;
}


