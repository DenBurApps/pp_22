import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22_copy/models/coin.dart';
import 'package:pp_22_copy/services/coin_api_service.dart';

class CameraSearchController extends ValueNotifier<CoinSearchResultState> {
  CameraSearchController() : super(CoinSearchResultState.initial());

  final _coinsApiService = GetIt.instance<CoinApiService>();

  Future<void> searchByImages({
    required Uint8List obverse,
    required Uint8List reverse,
  }) async {
    try {
      value = value.copyWith(isLoading: true);
      final seacrhedCoins =
          await _coinsApiService.getCoinsByImages(obverse, reverse);
      value = value.copyWith(searchedCoins: seacrhedCoins, isLoading: false);
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

class CoinSearchResultState {
  final List<ShortenedCoinData> searchedCoins;
  final bool isLoading;
  final String? errorMessage;

  CoinSearchResultState({
    required this.searchedCoins,
    required this.isLoading,
    this.errorMessage,
  });

  factory CoinSearchResultState.initial() => CoinSearchResultState(
        searchedCoins: [],
        isLoading: false,
      );

  CoinSearchResultState copyWith({
    List<ShortenedCoinData>? searchedCoins,
    bool? isLoading,
    String? errorMessage,
  }) =>
      CoinSearchResultState(
        searchedCoins: searchedCoins ?? this.searchedCoins,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
