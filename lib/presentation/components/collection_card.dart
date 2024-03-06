import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/models/collection.dart';
import 'package:pp_22/presentation/components/cover_builder.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFA8B3DA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: collection.coins.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.images.emptyCollection.image(
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Empty collection',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ],
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
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            '${collection.name}',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
        if (collection.coins.isNotEmpty) ...[
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Material(
              child: Text(
                '${collection.coins.length} ${collection.coins.length > 1 ? 'coins' : 'coin'}',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                    ),
              ),
            ),
          )
        ]
      ],
    );
  }
}
