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
import 'package:pp_22/presentation/modules/search/controller/query_search_controller.dart';
import 'package:pp_22/routes/routes.dart';

class QuerySearchView extends StatefulWidget {
  const QuerySearchView({super.key});

  @override
  State<QuerySearchView> createState() => _QuerySearchViewState();
}

class _QuerySearchViewState extends State<QuerySearchView> {
  final _queryController = TextEditingController();
  final _querySearchController = QuerySearchController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _querySearchController.tooltipAction(
        showSearchTooltip: () => showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: Text(
              'On the free version, you can search using search query only 4 times',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: Navigator.of(context).pop,
                child: Text(
                  'Got It',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _querySearchController.searchOnScroll(_queryController.text);
      }
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _search(String searchQuery) {
    if (searchQuery.isEmpty) return;
    if (_querySearchController.canUserSendQueryRequest) {
      _querySearchController.search(searchQuery);
    } else {
      Navigator.of(context).pushNamed(
        RouteNames.paywall,
        arguments: PaywallViewArguments(),
      );
    }
  }

  void _loadingRemainingOnScrolling(String searchQuery) {
    _querySearchController.searchOnScroll(searchQuery);
  }

  void _sort(SortType sortType) {
    _querySearchController.switchSortType(sortType);
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: CupertinoTextField(
                        autofocus: true,
                        clearButtonMode: OverlayVisibilityMode.always,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        controller: _queryController,
                        onSubmitted: _search,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                        prefix: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            padding: EdgeInsets.all(2),
                            alignment: Alignment.center,
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle),
                            child: Assets.icons.search.svg(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                        placeholder: 'Search',
                        placeholderStyle:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.5),
                                ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  const AppCloseButton(),
                ],
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _querySearchController,
                  builder: (context, value, child) {
                    if (value.isResponseReceived) {
                      if (value.searchedCoins.isNotEmpty) {
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
                          sort: _showSortSheet,
                          controller: _scrollController,
                          coins: coppiedCoins,
                          searchQuery: _queryController.text,
                          onEndScrollCallback: () =>
                              _loadingRemainingOnScrolling(
                                  _queryController.text),
                        );
                      } else {
                        return _NotFoundState(
                          refresh: () => _search(_queryController.text),
                        );
                      }
                    } else {
                      if (value.isLoading) {
                        return const _LoadingState();
                      } else if (value.errorMessage != null) {
                        return _ErrorState(
                          refresh: () => _search(_queryController.text),
                        );
                      } else {
                        return _EmptyState();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotFoundState extends StatelessWidget {
  final VoidCallback refresh;
  const _NotFoundState({required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.images.emptySearch.image(
          width: 148,
          height: 148,
        ),
        SizedBox(height: 20),
        Text(
          'Not found. Please, try again!',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        CupertinoButton(
          child: Icon(Icons.refresh_outlined),
          onPressed: refresh,
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback refresh;
  const _ErrorState({
    super.key,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Some error has occured. Please, try again!',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        CupertinoButton(
          child: Icon(Icons.refresh_outlined),
          onPressed: refresh,
        ),
      ],
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
        Assets.images.emptySearch.image(width: 148, height: 148),
        SizedBox(height: 20),
        Text(
          "Let's start searching",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }
}

class _LoadedState extends StatelessWidget {
  final List<Coin> coins;
  final String searchQuery;
  final ScrollController controller;
  final VoidCallback onEndScrollCallback;
  final VoidCallback sort;
  const _LoadedState({
    required this.coins,
    required this.searchQuery,
    required this.onEndScrollCallback,
    required this.controller,
    required this.sort,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Found: ',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
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
            controller: controller,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final coin = coins[index];
              return CoinTile(
                coin: coin,
                isSearchingCoinTile: true,
                onPressed: () => Navigator.of(context).pushNamed(
                  RouteNames.coinDetails,
                  arguments: CoinDetailsViewArguments(coin: coin),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
            itemCount: coins.length,
          ),
        ),
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
      padding: const EdgeInsets.only(top: 20),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => const ShimmerCoinTile(),
      separatorBuilder: (context, index) => SizedBox(height: 15),
      itemCount: 50,
    );
  }
}
