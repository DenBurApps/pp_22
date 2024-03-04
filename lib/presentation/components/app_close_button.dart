import 'package:flutter/material.dart';

class AppCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AppCloseButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? Navigator.of(context).pop,
      child: Container(
        alignment: Alignment.center,
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Icon(
          Icons.close,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
