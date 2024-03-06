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
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(40),
              ),
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
        ShimmerWidget(heigth: 80),
        SizedBox(height: 16),
        Column(
          children: [
            ShimmerWidget(heigth: 60),
            const SizedBox(height: 20),
            ShimmerWidget(heigth: 60),
          ],
        ),
        SizedBox(height: 16),
        Column(
          children: [
            ShimmerWidget(heigth: 20),
            const SizedBox(height: 20),
            ShimmerWidget(heigth: 140),
          ],
        ),
        SizedBox(height: 60), 
         ShimmerWidget(heigth: 50),
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
