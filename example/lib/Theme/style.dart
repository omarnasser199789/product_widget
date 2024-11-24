import 'package:flutter/material.dart';
import '../core/util/assets_manager.dart';


final Color iconsColor= const   Color.fromRGBO(189, 189, 189, 1);
final BorderRadiusGeometry nestedBorderRadius = BorderRadius.circular(5);
final BorderRadiusGeometry borderRadius = BorderRadius.circular(10);
final EdgeInsetsGeometry padding = const EdgeInsets.all(5);
final BoxDecoration backgroundBoxDecoration = BoxDecoration(
  image: DecorationImage(
    image: AssetImage(ImgAssets.background),
    fit: BoxFit.fill,
  ),
);