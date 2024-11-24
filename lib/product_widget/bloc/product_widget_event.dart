import 'package:ecapp_core_v2/product/domain/use_case/get/get_products_use_case.dart';

abstract class ProductWidgetEvent {}

class GetAllProductsEvent extends ProductWidgetEvent {
  GetProductsParams params;
  GetAllProductsEvent({required this.params});
}


