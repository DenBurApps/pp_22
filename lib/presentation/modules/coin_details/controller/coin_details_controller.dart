import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22/models/coin.dart';
import 'package:pp_22/models/collection.dart';
import 'package:pp_22/models/price.dart';
import 'package:pp_22/services/coin_api_service.dart';
import 'package:pp_22/services/repositories/collection_repository.dart';
import 'package:pp_22/services/repositories/subscription_repository.dart';
import 'package:uuid/uuid.dart';

class CoinDetailsController extends ValueNotifier<CoinDetailState> {
  CoinDetailsController(super.value) {
    _init(value.coin);
  }

  CollectionsRepository get collections => _collectionsRepository;

  Collection get selectedCollection => _collectionsRepository
      .value.data[_collectionsRepository.value.selectedIndex!];

  bool get userHasSelectedCollection => value.selectedCollection != null;

  bool get selectedCollectionContainsCoin =>
      value.selectedCollection?.coins.contains(value.coin) ?? false;

  bool get canUserUseCollections =>
      _subscriptionRepository.canUserUseCollections;

  final _collectionsRepository = GetIt.instance<CollectionsRepository>();
  final _subscriptionRepository = GetIt.instance<SubscriptionRepositoy>();

  final _apiService = GetIt.instance<CoinApiService>();

  Future<void> _init(Coin coin) async {
    if (coin is ShortenedCoinData) {
      await _getExpandedCoinData(coin);
    }

    Collection? selectedCollection;
    if (_collectionsRepository.value.selectedIndex != null) {
      selectedCollection = _collectionsRepository
          .value.data[_collectionsRepository.value.selectedIndex!];
    }
    value = value.copyWith(
      selectedCollection: selectedCollection,
    );
  }

  Future<void> _getExpandedCoinData(Coin coin) async {
    try {
      value = value.copyWith(isLoading: true);
      final expandedCoinData = await _apiService.getCoinById(coin.id);
      value = value.copyWith(coin: expandedCoinData, isLoading: false);
      getCoinPrice(expandedCoinData.id);
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> getCoinPrice(int coinId) async {
    try {
      value = value.copyWith(isPriceLoading: true);
      final price = await _apiService.getCoinPrice(coinId);
      value = value.copyWith(price: price, isPriceLoading: false);
    } catch (e) {
      value = value.copyWith(isPriceLoading: false);
    }
  }

  bool addToExistCollection(
    int collectionIndex,
    Collection collection,
  ) {
    if (collection.coins.contains(value.coin)) {
      return false;
    } else {
      final updatedCoinsArray = collection.coins
        ..add(value.coin as ExpandedCoinData);
      final updatedCollection = collection.copyWith(coins: updatedCoinsArray);
      _collectionsRepository.updateData(updatedCollection, collectionIndex);
      return true;
    }
  }

  void addToNewCollection(String name) {
    final newCollection = Collection(
      name: name,
      coins: [value.coin as ExpandedCoinData],
      id: const Uuid().v4(),
    );
    _collectionsRepository.createCollection(newCollection);
  }

  void addToSelectedCollection() {
    final collectionIndex = collections.value.selectedIndex!;
    final updatedCoinsArray = value.selectedCollection!.coins
      ..add(value.coin as ExpandedCoinData);
    final updatedCollection =
        selectedCollection.copyWith(coins: updatedCoinsArray);
    collections.updateData(updatedCollection, collectionIndex);
    value = value.copyWith(selectedCollection: updatedCollection);
  }

  void removeFromSelectedCollection() {
    final collectionIndex = collections.value.selectedIndex!;
    final updatedCoinsArray = value.selectedCollection!.coins
      ..remove(value.coin as ExpandedCoinData);
    final updatedCollection =
        selectedCollection.copyWith(coins: updatedCoinsArray);
    collections.updateData(updatedCollection, collectionIndex);
    value = value.copyWith(selectedCollection: updatedCollection);
  }
}

class CoinDetailState {
  final Coin coin;
  final Collection? selectedCollection;
  final bool isLoading;
  final bool isPriceLoading;
  final String? errorMessage;
  final Price? price;

  const CoinDetailState({
    required this.coin,
    required this.isLoading,
    this.errorMessage,
    required this.isPriceLoading,
    this.price,
    this.selectedCollection,
  });

  CoinDetailState copyWith({
    ExpandedCoinData? coin,
    bool? isLoading,
    bool? isPriceLoading,
    String? errorMessage,
    Price? price,
    bool? isInFavorites,
    Collection? selectedCollection,
  }) =>
      CoinDetailState(
        coin: coin ?? this.coin,
        price: price ?? this.price,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        isPriceLoading: isPriceLoading ?? this.isPriceLoading,
        selectedCollection: selectedCollection ?? this.selectedCollection,
      );
}
