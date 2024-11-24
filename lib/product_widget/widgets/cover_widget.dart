import 'package:flutter/material.dart';

import '../../core/widgets/cached_net_work_image.dart';

class CoverWidget extends StatelessWidget {
  const CoverWidget({super.key, required this.imageWidth, required this.imageHeight, required this.imageUrl, required this.accessKey});
  final double imageWidth;
  final double imageHeight;
  final String imageUrl;
  final String accessKey;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: (imageWidth/imageHeight>0)?imageWidth/imageHeight:1,
      child: CachedNetWorkImage(
        url: imageUrl,
        accessKey: accessKey,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
      ),
    );
  }

}
