import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22_copy/generated/assets.gen.dart';
import 'package:pp_22_copy/models/arguments.dart';
import 'package:pp_22_copy/models/coin.dart';
import 'package:pp_22_copy/presentation/components/app_banner.dart';
import 'package:pp_22_copy/presentation/components/app_button.dart';
import 'package:pp_22_copy/presentation/components/bottom_pop_up.dart';
import 'package:pp_22_copy/presentation/components/coin_tile.dart';
import 'package:pp_22_copy/presentation/modules/pages/collections/controllers/collection_controller.dart';
import 'package:pp_22_copy/routes/routes.dart';
import 'package:pp_22_copy/theme/custom_colors.dart';

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

  void _init() {
    _collectionConroller = CollectionController(
      CollectionState(
        collection: collectionViewArguments.collection,
        index: collectionViewArguments.index,
      ),
    );
  }

  void _rename(String newName) {
    if (newName.isNotEmpty) {
      _collectionConroller.rename(newName);
      Navigator.of(context).pop();
    }
  }

  void _deleteCollection() {
    _collectionConroller.delete();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
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

  void _moreAction() => showCupertinoModalPopup(
        context: context,
        builder: (context) => BottomPopUp(
          title: 'Collection Settings',
          body: [
            AppButton(
              label: 'Rename collection',
              onPressed: () {
                Navigator.of(context).pop();
                _showRenameDialog();
              },
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Delete collection',
              onPressed: _deleteCollection,
              backgroundColor: Theme.of(context).extension<CustomColors>()!.red,
            )
          ],
        ),
      );

  void _addCoin() => showCupertinoModalPopup(
        context: context,
        builder: (context) => BottomPopUp(
          title: 'Add coin',
          body: [
            AppButton(
              label: 'Identify by photo',
              onPressed: () =>
                  Navigator.of(context).popAndPushNamed(RouteNames.camera),
            ),
            const SizedBox(height: 20),
            AppOutlinedButton(
              label: 'Search by name',
              onPressed: () =>
                  Navigator.of(context).popAndPushNamed(RouteNames.search),
            )
          ],
        ),
      );

  void _showRenameDialog() => showCupertinoModalPopup(
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
                onPressed: () => _rename(_collectionNameController.text),
              )
            ],
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
                children: [
                  AppButtonWithWidget(
                    onPressed: Navigator.of(context).pop,
                    child: Assets.icons.back.svg(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _collectionConroller,
                      builder: (_, value, __) => AppBanner(
                        label:
                            '${value.collection.name} ${value.collection.coins.isEmpty ? '' : "(${value.collection.coins.length})"}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AppButtonWithWidget(
                    onPressed: _moreAction,
                    child: Assets.icons.more.svg(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _collectionConroller,
                  builder: (_, value, __) {
                    if (value.collection.coins.isEmpty) {
                      return Center(
                        child: Text(
                          'Empty collection',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      );
                    } else {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => CoinTile(
                          coin: value.collection.coins[index],
                          onPressed: () => Navigator.of(context).pushNamed(RouteNames.coinDetails, arguments: CoinDetailsViewArguments(coin: value.collection.coins[index],),),
                          edit: () => _edit(
                            index,
                            value.collection.coins[index],
                          ),
                        ),
                        separatorBuilder: (context, index) => Divider(
                          color: Theme.of(context).colorScheme.primary,
                          height: 30,
                        ),
                        itemCount: value.collection.coins.length,
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              AppButton(
                label: 'Add coin',
                onPressed: _addCoin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
