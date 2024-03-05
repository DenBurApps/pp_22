import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/models/arguments.dart';
import 'package:pp_22/models/coin.dart';
import 'package:pp_22/models/collection.dart';
import 'package:pp_22/presentation/components/app_back_button.dart';
import 'package:pp_22/presentation/components/app_button.dart';
import 'package:pp_22/presentation/components/bottom_pop_up.dart';
import 'package:pp_22/presentation/components/collection_card.dart';
import 'package:pp_22/presentation/components/cover_builder.dart';
import 'package:pp_22/presentation/components/new_collection_button.dart';
import 'package:pp_22/presentation/components/shimmers.dart';
import 'package:pp_22/presentation/modules/coin_details/controller/coin_details_controller.dart';

class CoinDetailsView extends StatefulWidget {
  final CoinDetailsViewArguments coinDetailsViewArguments;

  const CoinDetailsView({
    super.key,
    required this.coinDetailsViewArguments,
  });

  @override
  State<CoinDetailsView> createState() => _CoinDetailsViewState();

  factory CoinDetailsView.create(BuildContext context) {
    final coinDetailsViewArguments =
        ModalRoute.of(context)!.settings.arguments as CoinDetailsViewArguments;
    return CoinDetailsView(coinDetailsViewArguments: coinDetailsViewArguments);
  }
}

class _CoinDetailsViewState extends State<CoinDetailsView> {
  Coin get _coin => widget.coinDetailsViewArguments.coin;

  late final _collectionNameController = TextEditingController();

  late final CoinDetailsController _coinDetailsController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    _coinDetailsController = CoinDetailsController(
      CoinDetailState(
        coin: _coin,
        isLoading: false,
        isPriceLoading: false,
      ),
    );
  }

  void _addToNewCollection(String name) {
    if (name.isNotEmpty) {
      _coinDetailsController.addToNewCollection(name);
      Navigator.of(context).pop();
    }
  }

  void _addToExistCollection(Collection collection, int collectionIndex) {
    final wasAdded = _coinDetailsController.addToExistCollection(
        collectionIndex, collection);
    if (wasAdded) {
      Navigator.of(context).pop();
    } else {
      _showCoinAlreadyInCollectionDialog();
    }
  }

  void _showCoinAlreadyInCollectionDialog() => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            'Coin already in this collection',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: Navigator.of(context).pop,
              child: Text(
                'OK',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            )
          ],
        ),
      );

  Future<void> _showInfoDialog(String info) async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          info,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1200)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _showCollectionSelectDialog() {
    final collections = _coinDetailsController.collections.value.data;
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        return SizedBox(
          height: screenHeight * 0.85,
          child: BottomPopUp(
            title: 'Add to Collection',
            body: [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemCount: collections.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                    childAspectRatio: 170 / 195,
                  ),
                  itemBuilder: (context, index) => index == collections.length
                      ? NewCollectionButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showNewCollectionDialog();
                          },
                        )
                      : CollectionCard(
                          collection: collections[index],
                          onPressed: () =>
                              _addToExistCollection(collections[index], index),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              AppButton(
                onPressed: Navigator.of(context).pop,
                label: 'Close',
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _showNewCollectionDialog() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BottomPopUp(
          title: 'Name new collection',
          body: [
            SizedBox(
              height: 50,
              child: CupertinoTextField(
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                maxLength: 20,
                autofocus: true,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                controller: _collectionNameController,
              ),
            ),
            const SizedBox(height: 30),
            AppButton(
              label: 'Save',
              onPressed: () =>
                  _addToNewCollection(_collectionNameController.text),
            )
          ],
        ),
      ),
    );
    if (_collectionNameController.text.isNotEmpty) {
      _collectionNameController.clear();
    }
  }

  Future<void> _collectionButtonAction() async {
    if (_coinDetailsController.userHasSelectedCollection) {
      if (_coinDetailsController.selectedCollectionContainsCoin) {
        _coinDetailsController.removeFromSelectedCollection();
        _showInfoDialog(
            'Coin was deleted from "${_coinDetailsController.selectedCollection.name}"');
      } else {
        _coinDetailsController.addToSelectedCollection();
        _showInfoDialog(
            'Coin was added to "${_coinDetailsController.selectedCollection.name}"');
      }
    } else {
      _showCollectionSelectDialog();
    }
  }

  @override
  void dispose() {
    _collectionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
            child: Row(
              children: [
                AppBackButton(),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        child: ValueListenableBuilder(
          valueListenable: _coinDetailsController,
          builder: (context, value, child) {
            if (value.isLoading) {
              return const ShimmerCoinDetails();
            } else {
              return Column(
                children: [
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CoverBuilder(
                        url: value.coin.obverseThumbnail ?? '',
                        width: 125,
                        height: 125,
                      ),
                      CoverBuilder(
                        url: value.coin.reverseThumbnail ?? '',
                        width: 125,
                        height: 125,
                        isErrorReverse: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  _CoinDetails(
                    coin: value.coin as ExpandedCoinData,
                    coinDetailsController: _coinDetailsController,
                    collectionButtonAction: _collectionButtonAction,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class _CoinDetails extends StatelessWidget {
  final ExpandedCoinData coin;
  final CoinDetailsController coinDetailsController;
  final VoidCallback collectionButtonAction;

  const _CoinDetails({
    required this.coin,
    required this.coinDetailsController,
    required this.collectionButtonAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CoinHeader(coin: coin),
        SizedBox(height: 16),
        _CoinPricePreference(
          coin: coin,
          coinDetailsController: coinDetailsController,
        ),
        SizedBox(height: 16),
        _CoinParametrs(coin: coin),
        SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: coinDetailsController,
          builder: (context, value, child) => AppButton(
            label: coinDetailsController.selectedCollectionContainsCoin
                ? 'Remove coin'
                : 'Add coin',
            onPressed: collectionButtonAction,
          ),
        ),
      ],
    );
  }
}

class _CoinHeader extends StatelessWidget {
  final ExpandedCoinData coin;
  const _CoinHeader({required this.coin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        coin.description ?? "Empty coin description",
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _CoinPricePreference extends StatelessWidget {
  final Coin coin;
  final CoinDetailsController coinDetailsController;
  const _CoinPricePreference({
    required this.coin,
    required this.coinDetailsController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Text(
            'Reference Price',
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: coinDetailsController,
            builder: (context, value, child) {
              if (value.isPriceLoading) {
                return const ShimmerWidget(heigth: 47);
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        value.price == null
                            ? 'Price was not defined'
                            : '€${value.price!.left} - ${value.price!.rigth}',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Assets.icons.info.svg(
                      color: Theme.of(context).colorScheme.primary,
                      width: 18,
                      height: 18,
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Year:',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Color(0xFF887F7F)),
                ),
                const Spacer(),
                Text(
                  coin.minYear.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Color(0xFF413635)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CoinParametrs extends StatefulWidget {
  final ExpandedCoinData coin;
  const _CoinParametrs({required this.coin});

  @override
  State<_CoinParametrs> createState() => _CoinParametrsState();
}

class _CoinParametrsState extends State<_CoinParametrs> {
  void _showMoreDetailsDialog(String value, String parametr) =>
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            parametr,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          content: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: Navigator.of(context).pop,
              child: Text(
                'OK',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            )
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Text(
            'Physical features',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CoinParametr(
                        parametr: 'Thickness',
                        more: _showMoreDetailsDialog,
                        value: widget.coin.thickness != null
                            ? '${widget.coin.thickness}mm'
                            : '-',
                      ),
                      const SizedBox(height: 5),
                      _CoinParametr(
                        parametr: 'Edge',
                        more: _showMoreDetailsDialog,
                        value:
                            widget.coin.edge != null ? widget.coin.edge! : '-',
                      ),
                      const SizedBox(height: 5),
                      _CoinParametr(
                        parametr: 'Diameter',
                        more: _showMoreDetailsDialog,
                        value: widget.coin.size != null
                            ? '${widget.coin.size}mm'
                            : '-',
                      ),
                      const SizedBox(height: 5),
                      _CoinParametr(
                        parametr: 'Weight',
                        more: _showMoreDetailsDialog,
                        value: widget.coin.weight != null
                            ? '${widget.coin.weight}gr'
                            : '-',
                      ),
                    ],
                  ),
                ),
                Assets.icons.coinParams.svg(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinParametr extends StatelessWidget {
  final String parametr;
  final String value;
  final void Function(String value, String parameter) more;
  const _CoinParametr({
    required this.parametr,
    required this.value,
    required this.more,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => more(value, parametr),
      child: SizedBox(
        width: double.infinity,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$parametr: ',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
              TextSpan(
                text: value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
