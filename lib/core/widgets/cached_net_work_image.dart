import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../globals.dart';

class CachedNetWorkImage extends StatefulWidget {
  const CachedNetWorkImage({Key? key ,this.padding, this.imageHeight,this.imageWidth,this.url,this.border, this.borderRadius,this.boxFit}) : super(key: key);

  final String ?url;
  final BoxFit ?boxFit;
  final double ?imageWidth;
  final double ?imageHeight;
  final BorderRadiusGeometry? borderRadius;
  final  BoxBorder ? border;
  final  EdgeInsetsGeometry ? padding;
  @override
  State<CachedNetWorkImage> createState() => _CachedNetWorkImageState();
}

class _CachedNetWorkImageState extends State<CachedNetWorkImage> {

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius:widget.borderRadius??BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl:(widget.url!=null)?serverUrl+"${widget.url}":"https://picsum.photos/200/300",
        placeholder: (context, url) => Center(
          child: Shimmer.fromColors(
              baseColor:Theme.of(context).cardColor,
              highlightColor:  const Color.fromRGBO(119, 118, 118, 0.5490196078431373),
              child:  Container(
                color: Theme.of(context).cardColor,
                width: double.infinity,
                // height:100 ,
              )
          ),
        ),
        errorWidget: (context, url, error) => const Center(child: Icon(Icons.error,color: Colors.red,)),
        fit: widget.boxFit ??BoxFit.cover, // Image fitting
        width: widget.imageWidth, // Image width
        height: widget.imageHeight, // Image height
        alignment: Alignment.center, // Image alignment
      ),
    );
  }
}
