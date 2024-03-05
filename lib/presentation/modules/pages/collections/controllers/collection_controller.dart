
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22/models/collection.dart';
import 'package:pp_22/services/repositories/collection_repository.dart';

class CollectionController extends ValueNotifier<CollectionState> {
  CollectionController(super.value) {
    _init();
  }

  final collections = GetIt.instance<CollectionsRepository>();


  void _init() {
    collections.addListener(_handleLisnetningEvents);
  }

  void rename(String newName) {
    final updatedCollection = value.collection.copyWith(name: newName);
    collections.updateData(updatedCollection, value.index);
  }

  void delete() {
    collections.deleteCollection(value.collection, value.index);
  }

  void removeCoinFromCollection(int coinIndex) {
    final updatedCoinsArray = value.collection.coins..removeAt(coinIndex);
    final updatedCollection =
        value.collection.copyWith(coins: updatedCoinsArray);

    collections.updateData(updatedCollection, value.index);
  }

  void _handleLisnetningEvents() {
    if (collections.value.data.contains(value.collection)) {
      final repositoryInstance = collections.value.data[value.index];
      value = value.copyWith(collection: repositoryInstance);
    }
  }
}

class CollectionState {
  final Collection collection;
  final int index;

  const CollectionState({
    required this.collection,
    required this.index,
  });

  CollectionState copyWith({Collection? collection}) => CollectionState(
        collection: collection ?? this.collection,
        index: index,
      );
}
