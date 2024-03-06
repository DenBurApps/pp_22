import 'package:flutter/material.dart';
import 'package:pp_22/presentation/components/app_close_button.dart';

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
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 30),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                AppCloseButton(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...body,
        ],
      ),
    );
  }
}
