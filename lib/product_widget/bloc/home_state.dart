import 'package:ecapp_core/banner/domain/entities/pagination_banner_entity.dart';
import 'package:ecapp_core/category/domain/entities/category_entity.dart';
import 'package:ecapp_core/category/domain/entities/pagination_category_entity.dart';
import 'package:ecapp_core/product/domain/entities/pagination_product_entity.dart';
import 'package:ecapp_core/product/domain/entities/product_entity.dart';

abstract class HomeState {}

class PatientsInitial extends HomeState {}

class Loading extends HomeState {}

///Categories Section
class SuccessGetParentCategories extends HomeState {
  PaginationCategoryEntity categoriesEntity;
  SuccessGetParentCategories({required this.categoriesEntity});
}
class SuccessGetCategoriesByParentId extends HomeState {
  List<CategoryEntity> list;
  SuccessGetCategoriesByParentId({required this.list});
}
///Banners Section
///
class SuccessGetBanners extends HomeState {
  PaginationBannersEntity bannersEntity;
  SuccessGetBanners({required this.bannersEntity});
}

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


// class SuccessGetNewestProductsEntity extends HomeState {
//   List<ProductEntity> list;
//   SuccessGetNewestProductsEntity({required this.list});
// }




class Error extends  HomeState {
  final String message;

  Error({ required this.message}); //we use this constructor in ((BLOC & test))

  @override
  List<Object> get props => [message];
}

class Empty extends  HomeState {}
