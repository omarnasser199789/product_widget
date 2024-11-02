import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../util/assets_manager.dart';
class PlayButton extends StatelessWidget {
  final VoidCallback onTap;

  const PlayButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10000),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(ImgAssets.play),
          ),
        ),
      ),
    );
  }
}