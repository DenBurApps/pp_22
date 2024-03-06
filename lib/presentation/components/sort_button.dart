import 'package:flutter/cupertino.dart';
import 'package:pp_22/generated/assets.gen.dart';

class SortButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SortButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     
      child: Assets.icons.sort.svg(),
      onTap: onPressed,
    );
  }
}
