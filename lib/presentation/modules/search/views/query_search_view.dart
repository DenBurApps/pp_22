import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/models/arguments.dart';
import 'package:pp_22/models/coin.dart';
import 'package:pp_22/presentation/components/app_back_button.dart';
import 'package:pp_22/presentation/components/coin_tile.dart';
import 'package:pp_22/presentation/components/shimmers.dart';
import 'package:pp_22/presentation/modules/search/controller/query_search_controller.dart';
import 'package:pp_22/routes/routes.dart';

class QuerySearchView extends StatefulWidget {
  const QuerySearchView({super.key});

  @override
  State<QuerySearchView> createState() => _QuerySearchViewState();
}

class _QuerySearchViewState extends State<QuerySearchView> {
  final _queryController = TextEditingController();
  final _searchController = QuerySearchController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _search(String searchQuery) {
    if (searchQuery.isEmpty) return;
    _searchController.search(searchQuery);
  }

  void _loadingRemainingOnScrolling(String searchQuery) {
    _searchController.searchOnScroll(searchQuery);
  }

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
                  AppBackButton(),
                  SizedBox(width: 9),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: CupertinoTextField(
                        clearButtonMode: OverlayVisibilityMode.always,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        controller: _queryController,
                        onSubmitted: _search,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefix: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Assets.icons.search.svg(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        placeholder: 'Search',
                        placeholderStyle: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    if (value.isResponseReceived) {
                      if (value.searchedCoins.isNotEmpty) {
                        return _LoadedState(
                          coins: value.searchedCoins,
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
        Text(
          'Not found. Please, try again!',
          style: Theme.of(context).textTheme.headlineMedium,
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
          style: Theme.of(context).textTheme.headlineMedium,
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
    return Center(
      child: Text(
        "Let's start searching",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class _LoadedState extends StatelessWidget {
  final List<Coin> coins;
  final String searchQuery;
  final VoidCallback onEndScrollCallback;
  const _LoadedState({
    required this.coins,
    required this.searchQuery,
    required this.onEndScrollCallback,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          onEndScrollCallback.call();
        }
        return true;
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 20),
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
        separatorBuilder: (context, index) => Divider(
          color: Theme.of(context).colorScheme.primary,
          height: 30,
        ),
        itemCount: coins.length,
      ),
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
      separatorBuilder: (context, index) => Divider(
        color: Theme.of(context).colorScheme.primary,
        height: 30,
      ),
      itemCount: 50,
    );
  }
}
