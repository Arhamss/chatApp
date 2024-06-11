import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetImageWidget extends StatelessWidget {
  const AssetImageWidget({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (assetPath.endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
      );
    } else if (assetPath.endsWith('.png') || assetPath.endsWith('.jpg')) {
      return Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
