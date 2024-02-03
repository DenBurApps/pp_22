import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22_copy/models/arguments.dart';
import 'package:pp_22_copy/models/coin.dart';
import 'package:pp_22_copy/presentation/components/app_back_button.dart';
import 'package:pp_22_copy/presentation/components/app_banner.dart';
import 'package:pp_22_copy/presentation/components/coin_tile.dart';
import 'package:pp_22_copy/presentation/components/shimmers.dart';
import 'package:pp_22_copy/presentation/modules/search/controller/camera_search_controller.dart';
import 'package:pp_22_copy/routes/routes.dart';

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
                children: [
                  AppBackButton(
                    onPressed: Navigator.of(context).pop,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AppBanner(label: 'Seacrhing by images'),
                  ),
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
                      return _LoadedState(
                        coins: value.searchedCoins,
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
  const _LoadedState({
    required this.coins,
    this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return coins.isEmpty
        ? Column(
            children: [
              Text(
                'Not found',
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
            ],
          )
        : ListView.separated(
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
            separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).colorScheme.primary,
              height: 30,
            ),
            itemCount: coins.length,
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
      separatorBuilder: (context, index) => const Divider(
        color: Color(0xFFEEEEEE),
        height: 30,
      ),
      itemCount: 50,
    );
  }
}
