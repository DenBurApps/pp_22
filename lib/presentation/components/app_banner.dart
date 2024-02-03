import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  final String label;
  const AppBanner({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          )),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
