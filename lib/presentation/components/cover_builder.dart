import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:pp_22_copy/presentation/components/shimmers.dart';

class CoverBuilder extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final BoxFit? fit;
  final bool isErrorReverse;
    final String url;
  const CoverBuilder({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.radius = 80,
    this.fit = BoxFit.cover,
    this.isErrorReverse = false,
  });



  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.hardEdge,
      child: CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: url,
        placeholder: (context, url) => const ShimmerCoinThumbnail(),
        fit: fit,
        errorWidget: (context, url, error) => Container(),
      ),
    );
  }
}
