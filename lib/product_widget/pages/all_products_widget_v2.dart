/// Import necessary packages and files
import 'package:ecapp_core_v2/product/data/model/product_model.dart';
import 'package:ecapp_core_v2/product/domain/use_case/get/get_products_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:video_player/video_player.dart';
import '../bloc/bloc.dart';
import '../widgets/product_widget_v2.dart';


/// Widget responsible for displaying a paginated list of products
class AllProductsWidgetV2 extends StatefulWidget {
  const AllProductsWidgetV2({Key? key, this.catId,this.topPadding}) : super(key: key);
  final int? catId;
  final double? topPadding;

  @override
  State<AllProductsWidgetV2> createState() => _AllProductsWidgetV2State();
}

/// State class for AllProductsWidgetV2
class _AllProductsWidgetV2State extends State<AllProductsWidgetV2> {

  /// Controller for managing pagination logic
  final PagingController<int, ProductModel> _pagingController = PagingController(firstPageKey: 0);
  VideoPlayerController videoController = VideoPlayerController.networkUrl(Uri.parse(""));

  @override
  void initState() {
    /// Initialize the paging controller and add a listener for page requests
    _pagingController.addPageRequestListener((pageKey) {
      /// Trigger an event to fetch products from the HomeBloc
      BlocProvider.of<HomeBloc>(context).add(GetAllProductsEvent(params: GetProductsParams(page: pageKey, catId: widget.catId, pageSize: 7)));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          /// Handle different states emitted by the HomeBloc
          debugPrint(state.toString());

            if(state is SuccessGetAllProductsEntity){
            if(state.productsEntity.products.isEmpty){return const Center(child: Text("There is no items!"),); }

            /// If successful, append the received data to the paging controller
            final List<ProductModel> newData = state.productsEntity.products;

            if (_pagingController.nextPageKey != null) {
              /// Maintain a set to keep track of unique item IDs
              Set<String> uniqueItemIds = Set<String>.from(
                  _pagingController.itemList?.map((item) => item.id) ?? []);

              /// Filter out items that are already in the list
              List<ProductModel> filteredData =
              newData.where((item) => !uniqueItemIds.contains(item.id)).toList();

              /// Check if there are new items to append
              if (filteredData.isNotEmpty) {
                bool isLastPage = state.productsEntity.products.length == _pagingController.nextPageKey! + 1;

                if (isLastPage) {
                  _pagingController.appendLastPage(filteredData);
                } else {
                  final nextPageKey = _pagingController.nextPageKey! + 1;
                  _pagingController.appendPage(filteredData, nextPageKey);
                }
              }
            }
          }
          else if (state is Error) {
            /// If there's an error, set the error message in the paging controller
            _pagingController.error = state.message;
          }

          /// Display products in a paginated masonry grid view
          return PagedMasonryGridView.count(
            pagingController: _pagingController,
            padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 100, top: widget.topPadding ?? 0,),
            builderDelegate: PagedChildBuilderDelegate<ProductModel>(
              /// Build each product widget using the received data
              itemBuilder: (context, item, index) {
                /// Check if the product has attachments before building the widget
                if (item.attachments.isNotEmpty) {
                  return ProductWidgetV2(
                    title: item.titles,
                    attachments: item.attachments,
                    id: item.id,
                    videoController: videoController,
                  );
                }
                /// Return an empty container if there are no attachments
                return Container();
              },
            ),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          );
        },
      )
    );
  }
}
