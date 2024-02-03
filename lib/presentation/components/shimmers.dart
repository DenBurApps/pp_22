import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerArticle extends StatelessWidget {
  const ShimmerArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 340,
        height: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13), color: Colors.grey[600]),
      ),
    );
  }
}

class ShimmerCoinTile extends StatelessWidget {
  const ShimmerCoinTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 15,
                  width: double.infinity,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 7),
                Container(
                  height: 14,
                  width: double.infinity,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerCoinThumbnail extends StatelessWidget {
  const ShimmerCoinThumbnail({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

class ShimmerCoinDetails extends StatelessWidget {
  const ShimmerCoinDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ShimmerWidget(
              heigth: 125,
              width: 125,
              radius: 62,
            ),
            ShimmerWidget(
              heigth: 125,
              width: 125,
              radius: 62,
            )
          ],
        ),
        SizedBox(height: 20), 
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(13),
          ),
          child: ShimmerWidget(heigth: 80),
        ),
        SizedBox(height: 16),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            children: [
              ShimmerWidget(heigth: 60),
              const SizedBox(height: 20),
              ShimmerWidget(heigth: 60),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            children: [
              ShimmerWidget(heigth: 20),
              const SizedBox(height: 20),
              ShimmerWidget(heigth: 140),
            ],
          ),
        ),
      ],
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final double heigth;
  final double width;
  final double radius;
  const ShimmerWidget({
    super.key,
    required this.heigth,
    this.width = double.infinity,
    this.radius = 13,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(radius),
        ),
        height: heigth,
      ),
    );
  }
}
