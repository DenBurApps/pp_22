import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/models/coin.dart';
import 'package:pp_22/presentation/components/cover_builder.dart';

class CoinTile extends StatelessWidget {
  final Coin coin;
  final VoidCallback? onPressed;
  final Widget? title;
  final VoidCallback? edit;
  final bool isSearchingCoinTile;

  const CoinTile({
    super.key,
    required this.coin,
    this.edit,
    this.onPressed,
    this.title,
    this.isSearchingCoinTile = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          CoverBuilder(
            url: coin.obverseThumbnail ?? '',
            width: 70,
            height: 70,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title ??
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            coin.title,
                            style: Theme.of(context).textTheme.headlineMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                const SizedBox(height: 7),
                Text(
                  '${coin.minYear} - ${coin.maxYear}, ${coin.issuer}',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Color(0xFF887F7F),
                      ),
                ),
              ],
            ),
          ),
          if (!isSearchingCoinTile)
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: edit,
              child: Assets.icons.edit.svg(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}
