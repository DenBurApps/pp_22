import 'dart:math';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/models/collection.dart';
import 'package:pp_22/presentation/components/cover_builder.dart';

class BigCollectionCard extends StatelessWidget {
  final Collection collection;
  final VoidCallback onPressed;
  final VoidCallback delete;
  final VoidCallback edit;
  final VoidCallback addCoins;
  const BigCollectionCard({
    super.key,
    required this.collection,
    required this.onPressed,
    required this.delete,
    required this.edit,
    required this.addCoins,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onPressed,
                child: Container(
                  height: 270,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFA8B3DA),
                  ),
                  child: collection.coins.isEmpty
                      ? Center(
                          child: Text(
                            'Empty collection',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
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
                          itemCount: min(collection.coins.length, 9),
                        ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: DottedDecoration(
                borderRadius: BorderRadius.circular(20),
                shape: Shape.box,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CollectionOperationButton(
                    onPressed: edit,
                    icon: Assets.icons.edit,
                  ),
                  _CollectionOperationButton(
                    onPressed: addCoins,
                    icon: Assets.icons.addCoin,
                  ),
                  _CollectionOperationButton(
                    onPressed: delete,
                    icon: Assets.icons.delete,
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Text(
          collection.name,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        if (collection.coins.isNotEmpty) ...[
          SizedBox(height: 7),
          Text(
            '${collection.coins.length} ${collection.coins.length > 1 ? 'coins' : 'coin'}',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.5),
                ),
          ),
        ]
      ],
    );
  }
}

class _CollectionOperationButton extends StatelessWidget {
  final SvgGenImage icon;
  final VoidCallback onPressed;
  const _CollectionOperationButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: icon.svg(),
      onPressed: onPressed,
    );
  }
}
