import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/helpers/enums.dart';
import 'package:pp_22/models/arguments.dart';
import 'package:pp_22/models/coin.dart';
import 'package:pp_22/presentation/components/app_button.dart';
import 'package:pp_22/presentation/components/app_close_button.dart';
import 'package:pp_22/presentation/components/bottom_pop_up.dart';
import 'package:pp_22/presentation/components/coin_tile.dart';
import 'package:pp_22/presentation/components/sort_button.dart';
import 'package:pp_22/presentation/modules/pages/collections/controllers/collection_controller.dart';
import 'package:pp_22/routes/routes.dart';
import 'package:pp_22/theme/custom_colors.dart';

class CollectionView extends StatefulWidget {
  final CollectionViewArguments collectionViewArguments;
  const CollectionView({
    super.key,
    required this.collectionViewArguments,
  });

  @override
  State<CollectionView> createState() => _CollectionViewState();

  factory CollectionView.create(BuildContext context) {
    final collectionViewArguments =
        ModalRoute.of(context)!.settings.arguments as CollectionViewArguments;
    return CollectionView(collectionViewArguments: collectionViewArguments);
  }
}

class _CollectionViewState extends State<CollectionView> {
  CollectionViewArguments get collectionViewArguments =>
      widget.collectionViewArguments;

  late final CollectionController _collectionConroller;
  late final _collectionNameController =
      TextEditingController(text: _collectionConroller.value.collection.name);

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _collectionNameController.dispose();
    super.dispose();
  }

  void _sort(SortType sortType) {
    _collectionConroller.switchSortType(sortType);
    Navigator.of(context).pop();
  }

  void _init() {
    _collectionConroller = CollectionController(
      CollectionState(
        sortType: SortType.none,
        collection: collectionViewArguments.collection,
        index: collectionViewArguments.index,
      ),
    );
  }

  void _removeCoinFromCollection(int coinIndex) {
    _collectionConroller.removeCoinFromCollection(coinIndex);
    Navigator.of(context).pop();
  }

  void _edit(int coinIndex, ExpandedCoinData coin) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => BottomPopUp(
        title: coin.title,
        body: [
          AppButton(
            label: 'Remove',
            backgroundColor: Theme.of(context).extension<CustomColors>()!.red,
            onPressed: () => _removeCoinFromCollection(coinIndex),
          ),
        ],
      ),
    );
  }

  void _addCoin() => showCupertinoModalPopup(
        context: context,
        builder: (context) => BottomPopUp(
          title: 'Add coin',
          body: [
            AppButton(
                label: 'Identify by photo',
                onPressed: () {
                  if (_collectionConroller.canUserUseCollections) {
                    Navigator.of(context).popAndPushNamed(RouteNames.camera);
                  } else {
                    Navigator.of(context).popAndPushNamed(
                      RouteNames.paywall,
                      arguments: PaywallViewArguments(),
                    );
                  }
                }),
            const SizedBox(height: 30),
            AppOutlinedButton(
              label: 'Search by name',
              onPressed: () {
                if (_collectionConroller.canUserUseCollections) {
                  Navigator.of(context).popAndPushNamed(RouteNames.search);
                } else {
                  Navigator.of(context).popAndPushNamed(
                    RouteNames.paywall,
                    arguments: PaywallViewArguments(),
                  );
                }
              },
            )
          ],
        ),
      );

  void _showSortSheet() => showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: Text('Sort'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => _sort(SortType.none),
              child: Text('None'),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _sort(SortType.minYear),
              child: Text('Min year'),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _sort(SortType.maxYear),
              child: Text('Max year'),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: Navigator.of(context).pop,
            child: Text('Cancel'),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
            top: 18,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCloseButton(),
                  ValueListenableBuilder(
                    valueListenable: _collectionConroller,
                    builder: (_, value, __) => Text(
                      value.collection.name,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  SortButton(onPressed: _showSortSheet),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _collectionConroller,
                  builder: (_, value, __) {
                    if (value.collection.coins.isEmpty) {
                      return _EmptyState();
                    } else {
                      List<Coin> coppiedCoins = [];
                      switch (value.sortType) {
                        case SortType.none:
                          coppiedCoins.addAll(value.collection.coins);
                          break;
                        case SortType.maxYear:
                          coppiedCoins
                            ..addAll(value.collection.coins)
                            ..sort((a, b) => b.maxYear.compareTo(a.maxYear));
                          break;
                        case SortType.minYear:
                          coppiedCoins
                            ..addAll(value.collection.coins)
                            ..sort((a, b) => a.maxYear.compareTo(b.maxYear));
                          break;
                      }
                      return Scrollbar(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => CoinTile(
                            coin: coppiedCoins[index],
                            onPressed: () => Navigator.of(context).pushNamed(
                              RouteNames.coinDetails,
                              arguments: CoinDetailsViewArguments(
                                coin: coppiedCoins[index],
                              ),
                            ),
                            edit: () => _edit(
                              index,
                              value.collection.coins[index],
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 15),
                          itemCount: value.collection.coins.length,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              AppButton(
                label: 'Add coin',
                onPressed: _addCoin,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.images.emptyCollection.image(
          width: 148,
          height: 148,
        ),
        SizedBox(height: 20),
        Text(
          "You don't have a single coin\nin your collection",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        SizedBox(height: 10),
        Text(
          'Click on + to create one',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
        )
      ],
    );
  }
}
