import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/helpers/enums.dart';
import 'package:pp_22/models/arguments.dart';
import 'package:pp_22/models/coin.dart';
import 'package:pp_22/presentation/components/app_close_button.dart';
import 'package:pp_22/presentation/components/coin_tile.dart';
import 'package:pp_22/presentation/components/shimmers.dart';
import 'package:pp_22/presentation/components/sort_button.dart';
import 'package:pp_22/presentation/modules/search/controller/camera_search_controller.dart';
import 'package:pp_22/routes/routes.dart';

class CameraSearchView extends StatefulWidget {
  final CameraSearchViewArguments arguments;
  const CameraSearchView({super.key, required this.arguments});

  @override
  State<CameraSearchView> createState() => _CameraSearchViewState();

  factory CameraSearchView.create(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as CameraSearchViewArguments;
    return CameraSearchView(arguments: arguments);
  }
}

class _CameraSearchViewState extends State<CameraSearchView> {
  CameraSearchViewArguments get _arguments => widget.arguments;

  final _coinSearchResultController = CameraSearchController();

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() => _search();

  void _search() => _coinSearchResultController.searchByImages(
        obverse: _arguments.obverse,
        reverse: _arguments.reverse,
      );

  void _refresh() => _search();

  void _sort(SortType sortType) {
    _coinSearchResultController.switchSortType(sortType);
    Navigator.of(context).pop();
  }

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
                  SizedBox(width: 30),
                  Text(
                    'Searching by images',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const AppCloseButton(),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _coinSearchResultController,
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return const _LoadingState();
                    } else if (value.errorMessage != null) {
                      return Text(value.errorMessage!);
                    } else {
                      List<Coin> coppiedCoins = [];
                      switch (value.sortType) {
                        case SortType.none:
                          coppiedCoins.addAll(value.searchedCoins);
                          break;
                        case SortType.maxYear:
                          coppiedCoins
                            ..addAll(value.searchedCoins)
                            ..sort((a, b) => b.maxYear.compareTo(a.maxYear));
                          break;
                        case SortType.minYear:
                          coppiedCoins
                            ..addAll(value.searchedCoins)
                            ..sort((a, b) => a.maxYear.compareTo(b.maxYear));
                          break;
                      }
                      return _LoadedState(
                        coins: coppiedCoins,
                        sort: _showSortSheet,
                        refresh: _refresh,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadedState extends StatelessWidget {
  final List<Coin> coins;
  final VoidCallback? refresh;
  final VoidCallback sort;
  const _LoadedState({
    required this.coins,
    this.refresh,
    required this.sort,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (coins.isEmpty) ...[
          Assets.images.emptySearch.image(
            width: 148,
            height: 148,
          ),
          SizedBox(height: 10),
          Text(
            'Not a single coin was found\nat your request',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CupertinoButton(
            onPressed: refresh,
            child: Icon(
              Icons.refresh_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Found: ',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.5),
                              ),
                    ),
                    TextSpan(
                      text:
                          '${coins.length} ${coins.length > 1 ? 'coins' : 'coin'}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              SortButton(onPressed: sort)
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => CoinTile(
                coin: coins[index],
                isSearchingCoinTile: true,
                onPressed: () => Navigator.of(context).pushNamed(
                  RouteNames.coinDetails,
                  arguments: CoinDetailsViewArguments(
                    coin: coins[index],
                  ),
                ),
              ),
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemCount: coins.length,
            ),
          ),
        ]
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => const ShimmerCoinTile(),
      separatorBuilder: (context, index) => SizedBox(height: 15),
      itemCount: 50,
    );
  }
}
