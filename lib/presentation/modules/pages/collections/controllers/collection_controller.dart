import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22/helpers/enums.dart';
import 'package:pp_22/models/collection.dart';
import 'package:pp_22/services/repositories/collection_repository.dart';
import 'package:pp_22/services/repositories/subscription_repository.dart';

class CollectionController extends ValueNotifier<CollectionState> {
  CollectionController(super.value) {
    _init();
  }

  final _collectionsRepository = GetIt.instance<CollectionsRepository>();
  final _subscriptionRepository = GetIt.instance<SubscriptionRepositoy>() ;

    bool get canUserUseCollections =>
      _subscriptionRepository.canUserUseCollections;

  void _init() {
    _collectionsRepository.addListener(_handleLisnetningEvents);
  }

  void rename(String newName) {
    final updatedCollection = value.collection.copyWith(name: newName);
    _collectionsRepository.updateData(updatedCollection, value.index);
  }

  void delete() {
    _collectionsRepository.deleteCollection(value.collection, value.index);
  }

  void removeCoinFromCollection(int coinIndex) {
    final updatedCoinsArray = value.collection.coins..removeAt(coinIndex);
    final updatedCollection =
        value.collection.copyWith(coins: updatedCoinsArray);

    _collectionsRepository.updateData(updatedCollection, value.index);
  }

  void _handleLisnetningEvents() {
    if (_collectionsRepository.value.data.contains(value.collection)) {
      final repositoryInstance = _collectionsRepository.value.data[value.index];
      value = value.copyWith(collection: repositoryInstance);
    }
  }
    void switchSortType(SortType sortType) =>
      value = value.copyWith(sortType: sortType);
}

class CollectionState {
  final Collection collection;
  final int index;
  final SortType sortType;
  const CollectionState({
    required this.collection,
    required this.index,
    required this.sortType,
  });

  CollectionState copyWith({
    Collection? collection,
    SortType? sortType,
  }) =>
      CollectionState(
        collection: collection ?? this.collection,
        index: index,
        sortType: sortType ?? this.sortType,
      );
}
