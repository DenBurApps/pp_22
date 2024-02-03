import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22_copy/generated/assets.gen.dart';
import 'package:pp_22_copy/models/arguments.dart';
import 'package:pp_22_copy/presentation/components/app_banner.dart';
import 'package:pp_22_copy/presentation/components/app_button.dart';
import 'package:pp_22_copy/presentation/components/bottom_pop_up.dart';
import 'package:pp_22_copy/presentation/components/collection_card.dart';
import 'package:pp_22_copy/presentation/components/new_collection_button.dart';
import 'package:pp_22_copy/presentation/modules/pages/collections/controllers/collections_controller.dart';
import 'package:pp_22_copy/routes/routes.dart';

class CollectionsView extends StatefulWidget {
  const CollectionsView({super.key});

  @override
  State<CollectionsView> createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<CollectionsView> {
  final _collectionsController = CollectionsController();

  late final _collectionNameController = TextEditingController();

  @override
  void dispose() {
    _collectionNameController.dispose();
    super.dispose();
  }

  void _createCollection(String name) {
    if (name.isNotEmpty) {
      _collectionsController.createCollection(name);
      _collectionNameController.clear();
    }
    Navigator.of(context).pop();
  }

  void _showNewCollectionDialog() => showCupertinoModalPopup(
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
                  maxLength: 25,
                  autofocus: true,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary)),
                  controller: _collectionNameController,
                ),
              ),
              const SizedBox(height: 30),
              AppButton(
                label: 'Save',
                onPressed: () =>
                    _createCollection(_collectionNameController.text),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AppButtonWithWidget(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(RouteNames.search),
                    child: Row(
                      children: [
                        Assets.icons.search
                            .svg(color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'Search for coins',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.5),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AppButtonWithWidget(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(RouteNames.settings),
                  child: Assets.icons.settings
                      .svg(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppBanner(label: 'Collections'),
            const SizedBox(height: 24),
            ValueListenableBuilder(
              valueListenable: _collectionsController,
              builder: (context, value, child) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.collections.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) =>
                      index == value.collections.length
                          ? NewCollectionButton(
                              onPressed: _showNewCollectionDialog,
                            )
                          : CollectionCard(
                              onPressed: () => Navigator.of(context).pushNamed(
                                RouteNames.collection,
                                arguments: CollectionViewArguments(
                                  index: index,
                                  collection: value.collections[index],
                                ),
                              ),
                              collection: value.collections[index],
                            ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
