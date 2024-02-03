import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isActive = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: backgroundColor ??
              Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(isActive ? 1 : 0.5),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary
                    .withOpacity(isActive ? 1 : 0.5),
              ),
        ),
      ),
    );
  }
}

class AppButtonWithWidget extends StatelessWidget {
  final Color? backgorundColor;
  final Widget child;
  final VoidCallback? onPressed;
  final bool useShadow;
  const AppButtonWithWidget({
    super.key,
    this.backgorundColor,
    required this.child,
    this.onPressed,
    this.useShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: backgorundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(13),
        boxShadow: useShadow
            ? [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.grey.withOpacity(0.2),
                )
              ]
            : null,
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const AppOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            color: Theme.of(context).colorScheme.surface),
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
