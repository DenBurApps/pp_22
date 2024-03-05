import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/presentation/components/app_button.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppButtonWithWidget(
      onPressed: onPressed ?? Navigator.of(context).pop,
      child: Assets.icons.back.svg(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
