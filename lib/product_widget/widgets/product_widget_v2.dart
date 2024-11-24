import 'package:ecapp_core_v2/product/data/model/attachment.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../core/globals.dart';
import '../../core/widgets/cached_net_work_image.dart';
import '../../core/widgets/price_widget.dart';
import 'video_widget.dart';

/// Widget class representing a product item with video or image attachment
class ProductWidgetV2 extends StatefulWidget {
  final String title; // Product title
  final String id; // Product ID
  final List<Attachment> attachments; // List of attachments (videos/images)
  final VideoPlayerController videoController;

  const ProductWidgetV2({
    Key? key,
    required this.title,
    required this.id,
    required this.attachments,
    required this.videoController,
  }) : super(key: key);

  @override
  State<ProductWidgetV2> createState() => _ProductWidgetV2State();
}

class _ProductWidgetV2State extends State<ProductWidgetV2> {

  /// URL of the video attachment
  String _videoUrl = "";

  /// URL of the image attachment
  String _imageUrl = "";
  String _accessKey = "";
  double _imageWidth = 0.0;
  double _imageHeight = 0.0;
  bool showVideo =false;

  @override
  void initState() {
    super.initState();
    /// Find the first video attachment and initialize the video controller
    for (var item in widget.attachments) {

      if (item.isVideo) {
        _videoUrl = item.url;
        _imageUrl = item.thumbnail;
        _accessKey = item.password;
      } else {
        _accessKey = item.password;
        _imageUrl = item.url;
      }
      _imageWidth = item.width;
      _imageHeight = item.height;
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print(_imageUrl);
        print(_videoUrl);
        // goTo(context, (context) => ProductPage(id: widget.id, videoPlayerController: widget.videoController,));
      },
      child: Container(
        decoration: BoxDecoration(
          color:Theme.of(context).cardColor,
          /// You have to find the right border radius value
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product image or video with play button
            _buildProductImage(),

            /// Product details (title, price, reviews, etc.)
            _buildProductDetails(),
          ],
        ),
      ),
    );
  }

  /// Widget for displaying product image or video with play button
  Widget _buildProductImage() {
    return Padding(
      padding: padding,
      child: ClipRRect(
          borderRadius: nestedBorderRadius,
          child: (_videoUrl!="")?
          VideoWidget(
              imageUrl: _imageUrl,
              videoUrl: _videoUrl,
              accessKey: _accessKey,
              imageHeight: _imageHeight,
              imageWidth: _imageWidth)
              : _buildCachedNetworkImage()
      ),
    );
  }

  /// Widget for displaying cached network image
  Widget _buildCachedNetworkImage() {
    return AspectRatio(
      aspectRatio: (_imageWidth/_imageHeight>0)?_imageWidth/_imageHeight:1,
      child: CachedNetWorkImage(
        url: _imageUrl,
        accessKey: _accessKey,
        imageWidth: _imageWidth,
        imageHeight: _imageHeight,
      ),
    );
  }

  /// Widget for displaying product details (title, price, reviews, etc.)
  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dresses",style: Theme.of(context).textTheme.labelSmall,),
          Text("Incredible Rubber Fish",style:  Theme.of(context).textTheme.titleSmall,),
          const SizedBox(height: 3,),
          const PriceWidget(),
          const SizedBox(height: 3,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("250",style: Theme.of(context).textTheme.labelMedium,),
              const SizedBox(width: 4,),
              const Text("⭐️"),
              Text("350 Review",style: Theme.of(context).textTheme.labelSmall,),
            ],
          ),
        ],
      ),
    );
  }

}
