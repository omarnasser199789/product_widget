import 'package:ecapp_core/product/domain/use_case/get/get_lite_products_use_case.dart';
import 'package:ecapp_core/product/domain/use_case/get/get_product_by_id_use_case.dart';
import 'package:ecapp_core/product/domain/use_case/get/get_products_by_cat_id_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_widget/product_widget/bloc/success_error/either_success_or_error.dart';
import 'dart:async';
import '../../../../core/managers/video_caching_manager.dart';
import '../../../../core/managers/video_urls_manager.dart';
import '../../core/globals.dart';
import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  ///Products Section
  final GetLiteProductsUseCase _getLiteProductsUseCase;
  final GetProductsByCatIdUseCase _getProductsByCatIdUseCase;
  final GetProductByIdUseCase _getProductByIdUseCase;

  HomeBloc({
    ///Products Section
    required GetLiteProductsUseCase concreteGetLiteProductsUseCase,
    required GetProductsByCatIdUseCase concreteGetProductsByCatIdUseCase,
    required GetProductByIdUseCase concreteGetProductByIdUseCase,
  })  :
        ///Products Section
        _getLiteProductsUseCase = concreteGetLiteProductsUseCase,
        _getProductsByCatIdUseCase = concreteGetProductsByCatIdUseCase,
        _getProductByIdUseCase = concreteGetProductByIdUseCase,

        super(Empty());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {

    ///Products Section
    if(event is GetAllProductsEvent){
      yield Loading();
      final failureOrPhysician = await _getLiteProductsUseCase(event.params);
      yield* SuccessGetAllProductsOrErrorState(failureOrPhysician);
    }
    else if(event is GetProductsByCatIdEvent){
      yield Loading();
      final failureOrPhysician = await _getProductsByCatIdUseCase(event.id);
      yield* SuccessGetProductsBySubCatIdOrErrorState(failureOrPhysician);
    }
    else if(event is GetProductByIdEvent){
      yield Loading();
      final failureOrPhysician = await _getProductByIdUseCase(event.id);
      yield* SuccessGetProductByIdOrErrorState(failureOrPhysician);
    }

    else if(event is CachingProductsEvent){
      yield SuccessCacheVideos(productsEntity:event.productsEntity);
      List<String> videoUrls = [];
      // Extract video URLs using map and expand
      videoUrls.addAll(event.productsEntity.data.expand((item) =>
          item.attachments.where((attachment) => attachment.isVideo).map((attachment) => VideoUrlManager.generateVideoUrl(VideoQuality.p360AsMp4, serverUrl+attachment.url))));
      videoCachingManager.cacheVideos(videoUrls);
      // videoCachingManager.stopCaching();

    }
  }
}









