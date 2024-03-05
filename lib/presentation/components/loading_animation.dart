import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';

class LoadingAnimation extends StatelessWidget {
  final Alignment? alignment;
  const LoadingAnimation({super.key, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: Assets.animations.coinAnimation.lottie(),
    );
  }
}
