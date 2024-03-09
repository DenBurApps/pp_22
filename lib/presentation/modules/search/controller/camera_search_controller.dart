import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22/helpers/enums.dart';
import 'package:pp_22/models/coin.dart';
import 'package:pp_22/services/coin_api_service.dart';
import 'package:pp_22/services/repositories/subscription_repository.dart';

class CameraSearchController extends ValueNotifier<CoinSearchResultState> {
  CameraSearchController() : super(CoinSearchResultState.initial());

  final _coinsApiService = GetIt.instance<CoinApiService>();
  final _subscriptionRepository = GetIt.instance<SubscriptionRepositoy>();

  Future<void> searchByImages({
    required Uint8List obverse,
    required Uint8List reverse,
  }) async {
    try {
      value = value.copyWith(isLoading: true);
      final seacrhedCoins =
          await _coinsApiService.getCoinsByImages(obverse, reverse);
      _subscriptionRepository.decreaseSearchByPhotoCount();
      value = value.copyWith(searchedCoins: seacrhedCoins, isLoading: false);
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void switchSortType(SortType sortType) =>
      value = value.copyWith(sortType: sortType);
}

class CoinSearchResultState {
  final List<ShortenedCoinData> searchedCoins;
  final bool isLoading;
  final String? errorMessage;
  final SortType sortType;

  CoinSearchResultState({
    required this.searchedCoins,
    required this.isLoading,
    required this.sortType,
    this.errorMessage,
  });

  factory CoinSearchResultState.initial() => CoinSearchResultState(
        searchedCoins: [],
        isLoading: false,
        sortType: SortType.none,
      );

  CoinSearchResultState copyWith({
    List<ShortenedCoinData>? searchedCoins,
    bool? isLoading,
    String? errorMessage,
    SortType? sortType,
  }) =>
      CoinSearchResultState(
          searchedCoins: searchedCoins ?? this.searchedCoins,
          isLoading: isLoading ?? this.isLoading,
          errorMessage: errorMessage ?? this.errorMessage,
          sortType: sortType ?? this.sortType);
}
