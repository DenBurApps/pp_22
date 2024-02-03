import 'package:flutter/material.dart';
import 'package:pp_22_copy/generated/assets.gen.dart';

class BottomPopUp extends StatelessWidget {
  final String title;
  final List<Widget> body;
  final EdgeInsets? padding;
  const BottomPopUp({
    super.key,
    required this.title,
    required this.body,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 20),
              ...body,
            ],
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: Navigator.of(context).pop,
              child: Assets.icons.close.svg(
                width: 20, 
                height: 20,
                color: Theme.of(context).colorScheme.primary)
            ),
          )
        ],
      ),
    );
  }
}
