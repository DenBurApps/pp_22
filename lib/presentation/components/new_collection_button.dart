import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22_copy/generated/assets.gen.dart';

class NewCollectionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const NewCollectionButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              
              decoration: DottedDecoration(
                borderRadius: BorderRadius.circular(20),
                shape: Shape.box,
                color:
                    Theme.of(context).colorScheme.primary,
                dash: const [15, 15],
              ),
              child: Assets.icons.add.svg(
                color: Theme.of(context).colorScheme.primary,
                fit: BoxFit.none,
              ),
            ),
          ),
        ),
        Text(
          'New collection',
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: Color(0xFF413635)
              ),
        )
      ],
    );
  }
}