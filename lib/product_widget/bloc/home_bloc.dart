import 'package:ecapp_core_v2/product/domain/use_case/get/get_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_widget/product_widget/bloc/success_error/either_success_or_error.dart';
import 'dart:async';
import '../../../../core/managers/video_caching_manager.dart';
import '../../../../core/managers/video_urls_manager.dart';
import '../../core/globals.dart';
import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final GetProductsUseCase _getProductsUseCase;


  HomeBloc({
    required GetProductsUseCase concreteGetProductsUseCase
  })  :
        _getProductsUseCase = concreteGetProductsUseCase,
        super(Empty());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {

    ///Products Section
    if(event is GetAllProductsEvent){
      yield Loading();
      final failureOrPhysician = await _getProductsUseCase(event.params);
      yield* successGetAllProductsOrErrorState(failureOrPhysician);
    }

    // else if(event is CachingProductsEvent){
    //   yield SuccessCacheVideos(productsEntity:event.productsEntity);
    //   List<String> videoUrls = [];
    //   // Extract video URLs using map and expand
    //   videoUrls.addAll(event.productsEntity.products.expand((item) =>
    //       item.attachments.where((attachment) => attachment.isVideo).map((attachment) => VideoUrlManager.generateVideoUrl(VideoQuality.p360AsMp4, serverUrl+attachment.url))));
    //   videoCachingManager.cacheVideos(videoUrls);
    //   // videoCachingManager.stopCaching();
    //
    // }
  }
}









