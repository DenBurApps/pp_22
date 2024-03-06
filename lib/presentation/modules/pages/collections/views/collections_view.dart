import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/helpers/dialog_helper.dart';
import 'package:pp_22/models/arguments.dart';
import 'package:pp_22/models/collection.dart';
import 'package:pp_22/presentation/components/app_button.dart';
import 'package:pp_22/presentation/components/app_close_button.dart';
import 'package:pp_22/presentation/components/big_collection_card.dart';
import 'package:pp_22/presentation/components/bottom_pop_up.dart';
import 'package:pp_22/presentation/modules/pages/collections/controllers/collections_controller.dart';
import 'package:pp_22/routes/routes.dart';

class CollectionsView extends StatefulWidget {
  final bool isFromSettings;
  const CollectionsView({
    super.key,
    this.isFromSettings = false,
  });

  @override
  State<CollectionsView> createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<CollectionsView> {
  final _collectionsController = CollectionsController();

  late final _collectionNameController = TextEditingController();

  bool get _isFromSettings => widget.isFromSettings;

  @override
  void dispose() {
    _collectionNameController.dispose();
    super.dispose();
  }

  void _createCollection(String name) {
    if (name.isNotEmpty) {
      _collectionsController.createCollection(name);
    }
    Navigator.of(context).pop();
  }

  void _showNewCollectionDialog() => showCupertinoModalPopup(
        context: context,
        builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _NewCollectionPopUp(
            create: _createCollection,
          ),
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
            const SizedBox(height: 30),
            AppOutlinedButton(
              label: 'Search by name',
              onPressed: () =>
                  Navigator.of(context).popAndPushNamed(RouteNames.search),
            )
          ],
        ),
      );

  void _rename(String newName, int index) {
    if (newName.isNotEmpty) {
      _collectionsController.rename(
        newName,
        index,
      );
    }
    Navigator.of(context).pop();
  }

  void _showDeleteDialog(
    BuildContext context,
    int index,
  ) =>
      DialogHelper.showDeleteDialog(
        context,
        yes: () {
          _collectionsController.deleteCollection(index);
          Navigator.of(context).pop();
        },
        no: Navigator.of(context).pop,
      );

  void _showRenameDialog(int index, Collection collection) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BottomPopUp(
            title: 'Rename collection',
            body: [
              SizedBox(
                height: 50,
                child: CupertinoTextField(
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  maxLength: 20,
                  autofocus: true,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  controller: _collectionNameController..text = collection.name,
                ),
              ),
              const SizedBox(height: 30),
              AppButton(
                label: 'Save',
                onPressed: () => _rename(_collectionNameController.text, index),
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              if (_isFromSettings)
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppCloseButton(),
                ),
              const SizedBox(height: 10),
              if (!_isFromSettings) ...[
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(RouteNames.search),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary)),
                    child: Row(
                      children: [
                        Container(
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
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'Search for coins',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.5),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your collections',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Assets.icons.addCollection.svg(),
                    onPressed: _showNewCollectionDialog,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _collectionsController,
                  builder: (context, value, child) {
                    if (value.collections.isEmpty) {
                      return _EmptyState();
                    } else {
                      return Scrollbar(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => BigCollectionCard(
                            collection: value.collections[index],
                            delete: () => _showDeleteDialog(context, index),
                            addCoins: _addCoin,
                            edit: () => _showRenameDialog(
                              index,
                              value.collections[index],
                            ),
                            onPressed: () => Navigator.of(context).pushNamed(
                              RouteNames.collection,
                              arguments: CollectionViewArguments(
                                index: index,
                                collection: value.collections[index],
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 20),
                          itemCount: value.collections.length,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
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
        Assets.images.emptyCollections.image(
          width: 148,
          height: 148,
        ),
        SizedBox(height: 20),
        Text(
          "You don't have a single\ncollection",
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

class _NewCollectionPopUp extends StatefulWidget {
  final void Function(String name) create;
  const _NewCollectionPopUp({required this.create});

  @override
  State<_NewCollectionPopUp> createState() => _NewCollectionPopUpState();
}

class _NewCollectionPopUpState extends State<_NewCollectionPopUp> {
  final _newCollectionNameController = TextEditingController();

  @override
  void dispose() {
    _newCollectionNameController.dispose();
    super.dispose();
  }

  void _create() {
    if (_newCollectionNameController.text.isEmpty) return;
    widget.create.call(_newCollectionNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Text(
                    'Add collection',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
                AppCloseButton(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: CupertinoTextField(
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              maxLength: 25,
              autofocus: true,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.surface,
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary)),
              controller: _newCollectionNameController,
            ),
          ),
          const SizedBox(height: 30),
          AppButton(
            label: 'Save',
            onPressed: _create,
          )
        ],
      ),
    );
  }
}
