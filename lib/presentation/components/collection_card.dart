import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22_copy/models/collection.dart';
import 'package:pp_22_copy/presentation/components/cover_builder.dart';

class CollectionCard extends StatelessWidget {
  final Collection collection;
  final VoidCallback? onPressed;
  const CollectionCard({
    super.key,
    required this.collection,
    this.onPressed,
  });

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
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: collection.coins.isEmpty
                  ? Center(
                      child: Text(
                        'Empty collection',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: min(4, collection.coins.length),
                      itemBuilder: (context, index) {
                        final coin = collection.coins[index];
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: ClipRRect(
                            child: CoverBuilder(
                              url: coin.obverseThumbnail ?? '',
                              width: 46,
                              height: 46,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
        Text(
          '${collection.name} ${collection.coins.isEmpty ? '' : "(${collection.coins.length})"}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: Color(
                  0xFF413635,
                ),
              ),
        )
      ],
    );
  }
}
