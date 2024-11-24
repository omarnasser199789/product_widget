import 'package:ecapp_core_v2/product/domain/use_case/get/get_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_widget/product_widget/bloc/success_error/either_success_or_error.dart';
import 'dart:async';
import 'bloc.dart';

class ProductWidgetBloc extends Bloc<ProductWidgetEvent, ProductWidgetState> {

  final GetProductsUseCase _getProductsUseCase;


  ProductWidgetBloc({
    required GetProductsUseCase concreteGetProductsUseCase
  })  :
        _getProductsUseCase = concreteGetProductsUseCase,
        super(Empty());

  @override
  Stream<ProductWidgetState> mapEventToState(ProductWidgetEvent event) async* {

    ///Products Section
    if(event is GetAllProductsEvent){
      yield Loading();
      final failureOrPhysician = await _getProductsUseCase(event.params);
      yield* successGetAllProductsOrErrorState(failureOrPhysician);
    }
  }
}









